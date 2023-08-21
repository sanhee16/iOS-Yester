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
    func updateWeather(_ item: WeatherCardItemV2)
}

protocol MainViewModelOutput {
    var isProgressing: Observable<Bool> { get }
    var items: Observable<[WeatherCardItemV2]> { get }
    var onCompleteLoadPage: Observable<Bool> { get }
}

class DefaultMainViewModel: BaseViewModel {
    private let locationRespository: AnyRepository<Location>
    private let weatherService: `WeatherService`
    private let weatherServiceV2: WeatherServiceV2
    private let locationService: LocationService
    
    var isLoading: Bool = false
    var items: Observable<[WeatherCardItemV2]> = Observable([])
    var isProgressing: Observable<Bool> = Observable(true)
    var onCompleteLoadPage: Observable<Bool> = Observable(false)
    
    
    init(_ coordinator: AppCoordinator, locationRespository: AnyRepository<Location>, weatherService: WeatherService, weatherServiceV2: WeatherServiceV2, locationService: LocationService) {
        self.locationRespository = locationRespository
        self.weatherService = weatherService
        self.weatherServiceV2 = weatherServiceV2
        self.locationService = locationService
        super.init(coordinator)
    }
}

extension DefaultMainViewModel: MainViewModel {
    func viewDidLoad() {
    }
    
    func viewWillAppear() {
        self.onCompleteLoadPage.value = false
        self.setLocations()
        self.updateWeather(items.value[0])
    }
    
    func onClickAddLocation() {
        coordinator.presentSelectLocation()
    }
    
    func updateWeather(_ item: WeatherCardItemV2) {
        guard let idx = self.items.value.firstIndex(where: { a in
            a == item
        }) else { return }
        if self.isLoading || item.isLoaded {
            return
        }
        self.isLoading = true
        self.isProgressing.value = true
        let location = item.location
        print("call: \(location)")
        Publishers.Zip(
            self.weatherServiceV2.getForecastWeather(location),
            self.weatherServiceV2.getHistoryWeather(location)
        )
        .run(in: &self.subscription) {[weak self] ( forecastResponse: DataResponse<ForecastResponseV2, NetworkErrorV2>, historyResponse: DataResponse<HistoryResponseV2, NetworkErrorV2>) in
            guard let self = self, let forecastResponse = forecastResponse.value, let historyResponse = historyResponse.value else {
                self?.isProgressing.value = false
                self?.onCompleteLoadPage.value = true
                print(forecastResponse.error)
                print(historyResponse.error)
                self?.items.value[idx] = WeatherCardItemV2(location: location, currentWeather: nil, history: nil, forecast: [], isLoaded: true)
                return
            }
            let current = forecastResponse.current
            let forecast = forecastResponse.forecast.forecastday
            let history = historyResponse.forecast.forecastday.first
            
            self.items.value[idx] = WeatherCardItemV2(location: location, currentWeather: current, history: history, forecast: forecast, isLoaded: true)
            
            if !self.onCompleteLoadPage.value {
                self.onCompleteLoadPage.value = true
            }
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
        var newItems: [WeatherCardItemV2] = []
        print("[setLocation] \(Defaults.locations)")
        
        Defaults.locations.forEach { location in
            if let idx = previousItems.firstIndex(where: { item in
                item.location == location
            }) {
                newItems.append(previousItems[idx])
            } else {
                newItems.append(WeatherCardItemV2(location: location, currentWeather: nil, history: nil, forecast: [], isLoaded: false))
            }
        }
        //        self.items.value.removeAll()
        self.items.value = newItems
        print("[setLocation] \(self.items.value)")
        self.isLoading = false
    }
}
