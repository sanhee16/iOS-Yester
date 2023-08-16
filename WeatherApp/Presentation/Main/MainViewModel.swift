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
    func viewDidLoad()
    func onClickAddLocation()
//    func onClickDelete(location: Location)
//    func onClickStar(location: Location)
    func updateWeather(_ item: WeatherCardItem)
}

protocol MainViewModelOutput {
    var isProgressing: Observable<Bool> { get }
    var items: Observable<[WeatherCardItem]> { get }
    var onCompleteLoadPage: Observable<Bool> { get }
}

class DefaultMainViewModel: BaseViewModel {
    private let locationRespository: AnyRepository<Location>
    private let weatherService: WeatherService
    private let locationService: LocationService
    
    var isLoading: Bool = false
    var items: Observable<[WeatherCardItem]> = Observable([])
    var isProgressing: Observable<Bool> = Observable(true)
    var onCompleteLoadPage: Observable<Bool> = Observable(false)
    
    
    init(_ coordinator: AppCoordinator, locationRespository: AnyRepository<Location>, weatherService: WeatherService, locationService: LocationService) {
        self.locationRespository = locationRespository
        self.weatherService = weatherService
        self.locationService = locationService
        super.init(coordinator)
    }
}

extension DefaultMainViewModel: MainViewModel {
    func viewDidLoad() {
    }
    
    func viewWillAppear() {
        self.setLocations()
        self.updateWeather(items.value[0])
    }
    
    func onClickAddLocation() {
        coordinator.presentSelectLocation()
    }
    
    func updateWeather(_ item: WeatherCardItem) {
        guard let idx = self.items.value.firstIndex(where: { a in
            a == item
        }) else { return }
        if self.isLoading || item.isLoaded {
            return
        }
        self.isLoading = true
        self.isProgressing.value = true
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
                self?.items.value[idx] = WeatherCardItem(location: location,  currentWeather: nil, daily: [], hourly: [], threeHourly: [], isLoaded: true)
                return
            }
            let currentWeather = wr.current
            let dailyWeather = wr.daily
            let hourlyWeather = wr.hourly
            let threeHourly = th.list

            self.items.value[idx] = WeatherCardItem(location: location, currentWeather: currentWeather, daily: dailyWeather, hourly: hourlyWeather, threeHourly: threeHourly, isLoaded: true)
            self.isProgressing.value = false
        } complete: {[weak self] in
            guard let self = self else { return }
            self.isLoading = false
        }
    }
    
    func setLocations() {
        if self.isLoading {
            return
        }
        self.isLoading = true
        let previousItems = self.items.value
        var newItems: [WeatherCardItem] = []
        self.items.value.removeAll()
        
        Defaults.locations.forEach { location in
            if let idx = previousItems.firstIndex(where: { item in
                item.location == location
            }) {
                newItems.append(previousItems[idx])
            } else {
                newItems.append(WeatherCardItem(location: location,  currentWeather: nil, daily: [], hourly:[], threeHourly: [], isLoaded: false))
            }
        }
        self.items.value = newItems
        self.isLoading = false
    }
}
