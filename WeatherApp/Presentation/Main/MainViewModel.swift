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
    func updateWeather(_ item: WeatherItem)
}

protocol MainViewModelOutput {
    var isLoading: Observable<Bool> { get }
    var items: Observable<[WeatherItem]> { get }
}

class DefaultMainViewModel: BaseViewModel {
    private let locationRespository: AnyRepository<Location>
    private let weatherService: WeatherService
    private let locationService: LocationService
    var items: Observable<[WeatherItem]> = Observable([])
    var isLoading: Observable<Bool> = Observable(false)
    
    init(_ coordinator: AppCoordinator, locationRespository: AnyRepository<Location>, weatherService: WeatherService, locationService: LocationService) {
        self.locationRespository = locationRespository
        self.weatherService = weatherService
        self.locationService = locationService
        super.init(coordinator)
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
        let updateItem = Location(lat: location.lat, lon: location.lon, isStar: !location.isStar, isCurrent: location.isCurrent, name: location.name)
        try? self.locationRespository.update(item: updateItem)
        self.getLocations()
    }
    
    func onClickDelete(location: Location) {
        try? self.locationRespository.delete(item: location)
        self.getLocations()
    }
    
    //TODO: 여기 밑에 items 업데이트 어떻게 할건지 수정해야함
    // 카드 넘길때마다 정보가 없으면 api 호출
    func updateWeather(_ item: WeatherItem) {
        guard let idx = self.items.value.firstIndex(where: { a in
            a == item
        }) else { return }
        if self.isLoading.value || item.isLoaded {
            return
        }
        self.isLoading.value = true
        let location = item.location
        Publishers.Zip(
            self.weatherService.getOneCallWeather(location),
            self.weatherService.get3HourlyWeather(location)
        )
        .run(in: &self.subscription) {[weak self] (
            weatherResponse: DataResponse<WeatherResponse, NetworkError>,
            threeHourlyResponse: DataResponse<ThreeHourlyResponse, NetworkError>
        ) in
            guard let self = self, let wr = weatherResponse.value, let th = threeHourlyResponse.value else {
                self?.items.value[idx] = WeatherItem(location: location,  currentWeather: nil, dailyWeather: [], ThreeHourly: [], isLoaded: true)
                return
            }
            let currentWeather = wr.current
            let dailyWeather = wr.daily
            let threeHourly = th.list
            
            self.items.value[idx] = WeatherItem(location: location, currentWeather: currentWeather, dailyWeather: dailyWeather, ThreeHourly: threeHourly, isLoaded: true)
        } complete: {[weak self] in
            guard let self = self else { return }
            self.isLoading.value = false
        }
    }
    
    func getLocations() {
        if self.isLoading.value {
            return
        }
        self.isLoading.value = true
        let previousItems = self.items.value
        var newItems: [WeatherItem] = []
        self.items.value.removeAll()
        
        Defaults.locations.forEach { location in
            if let idx = previousItems.firstIndex(where: { item in
                item.location == location
            }) {
                newItems.append(previousItems[idx])
            } else {
                newItems.append(WeatherItem(location: location,  currentWeather: nil, dailyWeather: [], ThreeHourly: [], isLoaded: false))
            }
        }
        self.items.value = newItems
        self.isLoading.value = false
    }
}
