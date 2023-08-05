//
//  SplashViewModel.swift
//  WeatherApp
//
//  Created by sandy on 2023/08/04.
//
import Foundation
import Combine
import Alamofire
import CoreLocation

protocol SplashViewModel: SplashViewModelInput, SplashViewModelOutput { }

protocol SplashViewModelInput {
    func viewWillAppear()
    func viewDidLoad()
}

protocol SplashViewModelOutput {
    
}

class DefaultSplashViewModel: BaseViewModel, SplashViewModel {
    let weatherService: WeatherService
    let locationService: LocationService
    let locationRespository: AnyRepository<Location>
    
    init(_ coordinator: AppCoordinator, locationRespository: AnyRepository<Location>, weatherService: WeatherService, locationService: LocationService) {
        self.locationRespository = locationRespository
        self.weatherService = weatherService
        self.locationService = locationService
        super.init(coordinator)
    }
    
    func viewWillAppear() {
        
    }
    
    func viewDidLoad() {
        self.setCurrentLocation()
    }
    
    func bind() {
        
    }
    
    func getDefaultsLocations() {
        Defaults.locations.removeAll()
        self.locationRespository.getAll().forEach { location in
            Defaults.locations.append(location)
        }
        self.coordinator.presentMainView()
    }
    
    func setCurrentLocation() {
        self.locationService.requestLocation {[weak self] coordinate in
            guard let self = self else { return }
            self.weatherService.getReverseGeocoding(coordinate)
                .run(in: &self.subscription) {[weak self] response in
                    guard let self = self, let res = response.value?.first else { return }
                    if self.locationRespository.getAll(where: NSPredicate(format: "isCurrent == true")).count > 0 {
                        var currentItem = self.locationRespository.getAll(where: NSPredicate(format: "isCurrent == true")).first!
                        currentItem.lat = res.lat
                        currentItem.lon = res.lon
                        currentItem.name = res.localName
                        try? self.locationRespository.update(item: currentItem)
                    } else {
                        let location = Location(lat: res.lat, lon: res.lon, isStar: false, isCurrent: true, name: res.localName)
                        try? self.locationRespository.insert(item: location)
                    }
                } complete: { [weak self] in
                    guard let self = self else { return }
                    self.getDefaultsLocations()
                }
        }
    }
}
