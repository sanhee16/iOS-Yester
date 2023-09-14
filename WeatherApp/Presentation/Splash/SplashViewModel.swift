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
    let geocodingService: GeocodingService
    
    var onCompleteFirstTasks: PassthroughSubject<Bool, Error> = PassthroughSubject()
    var onCompleteSecondTasks: PassthroughSubject<Bool, Error> = PassthroughSubject()
    var onCompleteThirdTasks: PassthroughSubject<Bool, Error> = PassthroughSubject()
    
    init(_ coordinator: AppCoordinator, locationRespository: AnyRepository<Location>, weatherService: WeatherService, locationService: LocationService, geocodingService: GeocodingService) {
        self.locationRespository = locationRespository
        self.weatherService = weatherService
        self.locationService = locationService
        self.geocodingService = geocodingService
        
        super.init(coordinator)
    }
    
    func viewWillAppear() {
        
    }
    
    func viewDidLoad() {
        self.bind()
        self.locationService.authorStauts.observe(on: self) {[weak self] status in
            switch status {
            case .denied:
                print("TODO: 거절 alert 만든 후 앱 종료 or 권한 창 다시 띄우기")
                break
            case .authorizedAlways, .authorizedWhenInUse:
                self?.setCurrentLocation()
                break
            default:
                break
            }
        }
    }
    
    func bind() {
        self.onCompleteFirstTasks.sink { completion in
            print("[SPLASH] error!: \(completion)")
        } receiveValue: {[weak self] isComplete in
            if isComplete {
                self?.getDefaultsLocations()
            }
        }.store(in: &self.subscription)
        
        self.onCompleteSecondTasks.sink { completion in
            print("[SPLASH] error!: \(completion)")
        } receiveValue: {[weak self] isComplete in
            if isComplete {
                self?.setUnits()
            }
        }.store(in: &self.subscription)
        
        self.onCompleteThirdTasks.sink { completion in
            print("[SPLASH] error!: \(completion)")
        } receiveValue: {[weak self] isComplete in
            if isComplete {
                self?.coordinator.presentMainView()
            }
        }.store(in: &self.subscription)
    }
    
    // alert
    func setUnits() {
        if Defaults.firstLaunch {
            Defaults.firstLaunch = false
            self.coordinator.presentSelectUnitView {[weak self] in
                self?.loadUnits()
            }
        } else {
            loadUnits()
        }
    }
    
    func loadUnits() {
        C.weatherUnit = WeatherUnit(rawValue: Defaults.weatherUnit) ?? .metric
        self.onCompleteThirdTasks.send(true)
    }
    
    func getDefaultsLocations() {
        Defaults.locations.removeAll()
        self.locationRespository.getAll().forEach { location in
            Defaults.locations.append(location)
        }
        self.onCompleteSecondTasks.send(true)
    }
    
    func setCurrentLocation() {
        print("[SPLASH] setCurrentLocation")
        self.locationService.requestLocation {[weak self] coordinate in
            guard let self = self else { return }
            print("[SPLASH] requestLocation: coordinate: \(coordinate)")
            self.geocodingService.getReverseGeocoding(coordinate)
                .run(in: &self.subscription) {[weak self] response in
                    guard let self = self, let res = response.value else {
                        print("[SPLASH] requestLocation ERR")
                        self?.coordinator.presentAlertView(.ok(onClickOk: {
                            
                        }), title: "load_location_fail_title".localized(), message: "load_location_fail_description".localized())
                        return
                    }
                    print("[SPLASH] getReverseGeocoding")
                    if self.locationRespository.getAll(where: NSPredicate(format: "isCurrent == true")).count > 0 {
                        var currentItem = self.locationRespository.getAll(where: NSPredicate(format: "isCurrent == true")).first!
                        currentItem.lat = coordinate.latitude
                        currentItem.lon = coordinate.longitude
                        currentItem.name = res.name
                        currentItem.address = res.getAddress()
                        try? self.locationRespository.update(item: currentItem)
                    } else {
                        let location = Location(lat: coordinate.latitude, lon: coordinate.longitude, isStar: false, isCurrent: true, name: res.name, address: res.getAddress())
                        try? self.locationRespository.insert(item: location)
                    }
                    self.onCompleteFirstTasks.send(true)
                } complete: {
                    print("[SPLASH] requestLocation complete")
                }
        } error: {[weak self] err in
            guard let self = self else { return }
            print("[SPLASH] err!!: \(err)")
            self.onCompleteFirstTasks.send(completion: .failure(err))
        }
    }
}
