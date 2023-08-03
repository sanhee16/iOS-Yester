//
//  MainView.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/11.
//

import Foundation
import Alamofire
import Combine

protocol MainViewModel: MainViewModelInput, MainViewModelOutput { }

protocol MainViewModelInput {
    func viewWillAppear()
    func onClickAddLocation()
    func onClickDelete(location: Location)
    func onClickStar(location: Location)
}

protocol MainViewModelOutput {
    var items: Observable<[WeatherItem]> { get }
}

class DefaultMainViewModel: BaseViewModel {
    private let locationRespository: AnyRepository<Location>
    private let weatherService: WeatherService
    var items: Observable<[WeatherItem]> = Observable([])
    
    init(_ coordinator: AppCoordinator, locationRespository: AnyRepository<Location>, weatherService: WeatherService) {
        self.locationRespository = locationRespository
        self.weatherService = weatherService
        super.init(coordinator)
    }
    
    func getLocations() {
        let previousItems = self.items.value
        self.items.value.removeAll()
        
        locationRespository.getAll().forEach { location in
            if let idx = previousItems.firstIndex(where: { item in
                item.location == location
            }) {
                self.items.value.append(previousItems[idx])
            } else {
                Publishers.Zip(
                    self.weatherService.getOneCallWeather(location),
                    self.weatherService.get3HourlyWeather(location)
                )
                .run(in: &self.subscription) {(
                    weatherResponse: DataResponse<WeatherResponse, NetworkError>,
                    threeHourlyResponse: DataResponse<ThreeHourlyResponse, NetworkError>
                ) in
                    guard let wr = weatherResponse.value, let th = threeHourlyResponse.value else {
                        self.items.value.append(WeatherItem(location: location,  currentWeather: nil, dailyWeather: [], ThreeHourly: []))
                        return
                    }
                    let currentWeather = wr.current
                    let dailyWeather = wr.daily
                    let threeHourly = th.list
                    self.items.value.append(WeatherItem(location: location, currentWeather: currentWeather, dailyWeather: dailyWeather, ThreeHourly: threeHourly))
                } complete: {[weak self]  in
                    guard let self = self else { return }
                }
            }
        }
    }
}

extension DefaultMainViewModel: MainViewModel {
    func viewWillAppear() {
        self.getLocations()
    }
    
    func onClickAddLocation() {
        coordinator.presentSelectLocation()
    }
    
    func onClickStar(location: Location) {
        let updateItem = Location(lat: location.lat, lon: location.lon, isStar: !location.isStar, isCurrent: location.isCurrent)
        try? self.locationRespository.update(item: updateItem)
        self.getLocations()
    }
    
    func onClickDelete(location: Location) {
        try? self.locationRespository.delete(item: location)
        self.getLocations()
    }
}
