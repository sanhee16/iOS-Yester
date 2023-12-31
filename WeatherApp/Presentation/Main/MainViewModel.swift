//
//  MainView.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/11.
//

import Foundation
import Alamofire
import Combine
import UIKit

enum UpdateStatus {
    case none
    case reload([WeatherCardItem])
    case load(Int, WeatherCardItem)
}

protocol MainViewModel: MainViewModelInput, MainViewModelOutput { }

protocol MainViewModelInput {
    func viewWillAppear()
    func viewDidLoad()
    func onClickAddLocation()
    func onClickRefresh()
    func onClickManageLocation()
    func onClickSetting()
    func updateWeather(_ idx: Int, onDone: ((WeatherCardItem?)->())?)
    func updateBackgroundColor(_ color: UIColor)
}

protocol MainViewModelOutput {
    var isLoading: Observable<Bool> { get }
    var items: [WeatherCardItem] { get }
    var updateStatus: Observable<UpdateStatus> { get }
    var backgroundColor: Observable<UIColor> { get }
    var lastUpdateText: Observable<String> { get }
}

class DefaultMainViewModel: BaseViewModel {
    private let locationRepository: LocationRepository
    private let weatherService: `WeatherService`
    private let weatherServiceV2: WeatherServiceV2
    private let locationService: LocationService
    
    var isLoading: Observable<Bool> = Observable(false)
    var items: [WeatherCardItem] = []
    var isFirstLoad: Bool = true
    var updateStatus: Observable<UpdateStatus> = Observable(.none)
    var lastUnit: WeatherUnit = C.weatherUnit
    var backgroundColor: Observable<UIColor> = Observable(.backgroundColor)
    var lastUpdateText: Observable<String> = Observable("")
    
    
    init(_ coordinator: AppCoordinator, locationRepository: LocationRepository, weatherService: WeatherService, weatherServiceV2: WeatherServiceV2, locationService: LocationService) {
        print("init!")
        self.locationRepository = locationRepository
        self.weatherService = weatherService
        self.weatherServiceV2 = weatherServiceV2
        self.locationService = locationService
        super.init(coordinator)
    }
}

extension DefaultMainViewModel: MainViewModel {
    
    func viewDidLoad() {
        print("[LOCATION] VM viewDidLoad")
    }
    
    func viewWillAppear() {
        print("[LOCATION] VM viewWillAppear")
        self.isLoading.value = false
        self.isFirstLoad = true
        self.updateStatus.value = .none
        
        if self.lastUnit != C.weatherUnit {
            self.items.removeAll()
            self.lastUnit = C.weatherUnit
        }
        self.loadLocations()
    }
    
    func onClickRefresh() {
        let current = Date()
        let updated = Date(timeIntervalSince1970: TimeInterval(C.lastUpdate ?? Int(current.timeIntervalSince1970)))
        
        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.hour, .minute], from: current)
        let updatedComponents = calendar.dateComponents([.hour, .minute], from: updated)

        let difference = calendar.dateComponents([.minute], from: updatedComponents, to: currentComponents).minute!
        print("differnence: \(difference)")
        if difference <= 10 {
            // 마지막 업데이트로부터 10분 이내이면 시간만 업데이트하기!
            self.isLoading.value = true

            C.lastUpdate = Int(Date().timeIntervalSince1970)
            if let lastUpdate = C.lastUpdate {
                self.lastUpdateText.value = Utils.intervalToHourMin(lastUpdate)
            }
            self.isLoading.value = false
            self.updateStatus.value = .reload(self.items)
        } else {
            self.items.removeAll()
            self.loadLocations()
        }
        
    }
    
    func onClickAddLocation() {
        coordinator.presentSelectLocation()
    }
    
    func updateBackgroundColor(_ color: UIColor) {
        self.backgroundColor.value = color
    }
    
    func updateWeather(_ idx: Int, onDone: ((WeatherCardItem?)->())? = nil) {
        if self.isLoading.value || self.items[idx].isLoaded {
            onDone?(self.items[idx])
            return
        }
        
        self.isLoading.value = true
        print("[MainVC] updateWeather: \(idx)")
        
        let location = self.items[idx].location
        
        
        Publishers.Zip3 (
            self.weatherService.getOneCallWeather(location),
            self.weatherService.get3HourlyWeather(location),
            self.weatherServiceV2.getHistoryWeather(location)
        )
        .run(in: &self.subscription) {[weak self] (weather, threeHourWeather, historyWeather) in
            guard let self = self, let weather = weather.value, let threeHourWeather = threeHourWeather.value, let yesterday = historyWeather.value?.forecast.forecastday.first else {
                self?.items[idx] = WeatherCardItem(location: location, currentWeather: nil, daily: [], hourly: [], threeHourly: [], isLoaded: true, yesterday: nil)
                self?.isLoading.value = false
                onDone?(self?.items[idx])
                return
            }
            
            let current = weather.current
            let daily = weather.daily
            let hourly = weather.hourly
            
            self.items[idx] = WeatherCardItem(location: location, currentWeather: current, daily: daily, hourly: hourly, threeHourly: threeHourWeather.list, isLoaded: true, yesterday: yesterday)
            
            self.isLoading.value = false
            onDone?(self.items[idx])
        } complete: {
            
        }
    }
    
    func loadLocations() {
        if self.isLoading.value {
            return
        }
        self.isLoading.value = true
        let previousItems = self.items
        var newItems: [WeatherCardItem] = []
        
        Defaults.locations.forEach { location in
            if let idx = previousItems.firstIndex(where: { item in
                item.location == location
            }) {
                newItems.append(previousItems[idx])
            } else {
                newItems.append(WeatherCardItem(location: location, daily: [], hourly: [], threeHourly: [], isLoaded: false, yesterday: nil))
            }
        }
        
        self.items = newItems
        
        C.lastUpdate = Int(Date().timeIntervalSince1970)
        if let lastUpdate = C.lastUpdate {
            self.lastUpdateText.value = Utils.intervalToHourMin(lastUpdate)
        }
        self.isLoading.value = false
        
        self.updateStatus.value = .reload(self.items)
    }
    
    func onClickManageLocation() {
        self.coordinator.presentManageLocation()
    }
    
    func onClickSetting() {
        self.coordinator.presentSetting()
    }
}
