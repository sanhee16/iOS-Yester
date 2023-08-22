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
    func onChangePage(_ idx: Int)
}

protocol MainViewModelOutput {
    var items: Observable<[WeatherCardItemV2]> { get }
}

class DefaultMainViewModel: BaseViewModel {
    private let locationRespository: AnyRepository<Location>
    private let weatherService: `WeatherService`
    private let weatherServiceV2: WeatherServiceV2
    private let locationService: LocationService
    
    var isLoading: Bool = false
    var items: Observable<[WeatherCardItemV2]> = Observable([])
    
    
    init(_ coordinator: AppCoordinator, locationRespository: AnyRepository<Location>, weatherService: WeatherService, weatherServiceV2: WeatherServiceV2, locationService: LocationService) {
        print("init!")
        self.locationRespository = locationRespository
        self.weatherService = weatherService
        self.weatherServiceV2 = weatherServiceV2
        self.locationService = locationService
        super.init(coordinator)
    }
}

extension DefaultMainViewModel: MainViewModel {
    
    func viewDidLoad() { }
    
    func viewWillAppear() {
        print("[MainVC] viewWillAppear")
        self.loadLocations()
        
        self.updateWeather(0) {[weak self] in
            guard let self = self else { return }
            if self.items.value.count > 1 {
                self.updateWeather(1)
            }
        }
    }
    
    func onClickAddLocation() {
        coordinator.presentSelectLocation()
    }
    
    func onChangePage(_ idx: Int) {
        if idx >= self.items.value.count {
            return
        }
        if self.items.value[idx].isLoaded {
            return
        }
        self.updateWeather(idx) {[weak self] in
            guard let self = self else { return }
            let idx2 = idx + 1
            if idx2 >= self.items.value.count {
                return
            }
            if self.items.value[idx2].isLoaded {
                return
            }
            self.updateWeather(idx2)
        }
    }
    
    func updateWeather(_ idx: Int, onDone: (()->())? = nil) {
        if self.isLoading {
            onDone?()
            return
        }
        self.isLoading = true
        print("[MainVC] updateWeather: \(idx)")
        
        let location = self.items.value[idx].location
        
        Publishers.Zip(
            self.weatherServiceV2.getForecastWeather(location),
            self.weatherServiceV2.getHistoryWeather(location)
        )
        .run(in: &self.subscription) {[weak self] ( forecastResponse: DataResponse<ForecastResponseV2, NetworkErrorV2>, historyResponse: DataResponse<HistoryResponseV2, NetworkErrorV2>) in
            guard let self = self, let forecastResponse = forecastResponse.value, let historyResponse = historyResponse.value else {
                self?.items.value[idx] = WeatherCardItemV2(location: location, currentWeather: nil, history: nil, forecast: [], isLoaded: true)
                self?.isLoading = false
                onDone?()
                return
            }
            let current = forecastResponse.current
            let forecast = forecastResponse.forecast.forecastday
            let history = historyResponse.forecast.forecastday.first
            
            self.items.value[idx] = WeatherCardItemV2(location: location, currentWeather: current, history: history, forecast: forecast, isLoaded: true)
            self.isLoading = false
            
            onDone?()
        } complete: {
            
        }
    }
    
    func loadLocations() {
        if self.isLoading {
            return
        }
        self.isLoading = true
        let previousItems = self.items.value
        var newItems: [WeatherCardItemV2] = []
        
        Defaults.locations.forEach { location in
            if let idx = previousItems.firstIndex(where: { item in
                item.location == location
            }) {
                newItems.append(previousItems[idx])
            } else {
                newItems.append(WeatherCardItemV2(location: location, currentWeather: nil, history: nil, forecast: [], isLoaded: false))
            }
        }
        self.items.value = newItems
        self.isLoading = false
    }
}
