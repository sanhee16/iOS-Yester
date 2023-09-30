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
import UIKit
import AppTrackingTransparency
import AdSupport
import UserNotifications

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
    let locationRepository: LocationRepository
    let geocodingService: GeocodingService
    
    var onCompleteTask1: PassthroughSubject<Bool, Error> = PassthroughSubject()
    var onCompleteTask2: PassthroughSubject<Bool, Error> = PassthroughSubject()
    var onCompleteTask3: PassthroughSubject<Bool, Error> = PassthroughSubject()
    var onCompleteTask4: PassthroughSubject<Bool, Error> = PassthroughSubject()
    
    init(_ coordinator: AppCoordinator, locationRepository: LocationRepository, weatherService: WeatherService, locationService: LocationService, geocodingService: GeocodingService) {
        self.locationRepository = locationRepository
        self.weatherService = weatherService
        self.locationService = locationService
        self.geocodingService = geocodingService
        
        super.init(coordinator)
    }
    
    func viewWillAppear() { }
    func viewDidLoad() {
        self.doTask()
    }
    
    func doTask() {
        self.locationService.authorStauts.observe(on: self) {[weak self] status in
            guard let self = self else { return }
            switch status {
            case .denied:
                self.coordinator.presentAlertView(.yesOrNo(onClickYes: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }, onClickNo: {
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        exit(0)
                    }
                }), title: "permission_denied_title".localized(), message: "permission_denied_description".localized())
                break
            case .authorizedAlways, .authorizedWhenInUse:
                self.setCurrentLocation()
                break
            default:
                break
            }
        }
        
        self.onCompleteTask1.sink { completion in
            print("[SPLASH] error!: \(completion)")
        } receiveValue: {[weak self] isComplete in
            if isComplete {
                self?.askTrackingPermission()
            }
        }.store(in: &self.subscription)
        
        self.onCompleteTask2.sink {  completion in
            print("[SPLASH] error!: \(completion)")
        } receiveValue: {[weak self] isComplete in
            if isComplete {
                self?.askNotificationPermission()
            }
        }.store(in: &self.subscription)
        
        self.onCompleteTask3.sink {  completion in
            print("[SPLASH] error!: \(completion)")
        } receiveValue: {[weak self] isComplete in
            if isComplete {
                self?.getDefaultsLocations()
                self?.setUnits()
            }
        }.store(in: &self.subscription)
        
        self.onCompleteTask4.sink {  completion in
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
        self.onCompleteTask4.send(true)
    }
    
    func getDefaultsLocations() {
        Defaults.locations.removeAll()
        self.locationRepository.getAll().forEach { location in
            Defaults.locations.append(location)
        }
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
                    self.locationRepository.updateCurrentLocation(lat: coordinate.latitude, lon: coordinate.longitude, name: res.name, address: res.getAddress())
                    self.onCompleteTask1.send(true)
                } complete: {
                    print("[SPLASH] requestLocation complete")
                }
        } error: {[weak self] err in
            guard let self = self else { return }
            print("[SPLASH] err!!: \(err)")
            self.onCompleteTask1.send(false)
        }
    }
    
    func askTrackingPermission() {
        ATTrackingManager.requestTrackingAuthorization {[weak self] _ in
            DispatchQueue.main.async {
                self?.onCompleteTask2.send(true)
            }
        }
    }
    
    func askNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings {[weak self] status in
            print(status.alertSetting)
            print(status.authorizationStatus)
            
            switch status.authorizationStatus {
            case .notDetermined:
                DispatchQueue.main.async {
                    self?.onCompleteTask3.send(true)
                }
                break
            default:
                DispatchQueue.main.async {
                    self?.onCompleteTask3.send(true)
                }
                return
            }
        }
    }
}
