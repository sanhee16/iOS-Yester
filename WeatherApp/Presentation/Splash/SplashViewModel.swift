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
    
    let onCompleteSetCurrentLocation: CurrentValueSubject<Bool, Error>
    
    init(_ coordinator: AppCoordinator, locationRespository: AnyRepository<Location>, weatherService: WeatherService, locationService: LocationService) {
        self.locationRespository = locationRespository
        self.weatherService = weatherService
        self.locationService = locationService
        
        self.onCompleteSetCurrentLocation = CurrentValueSubject<Bool, Error>(true)
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
        self.onCompleteSetCurrentLocation
            .sink {[weak self] completion in
                switch completion {
                case .failure:
                    print("Error가 발생하였습니다.")
                    
                case .finished:
                    print("finished")
                    self?.getDefaultsLocations()
                }
            } receiveValue: {[weak self] isDone in
                if isDone {
                    print("isDone")
                    self?.getDefaultsLocations()
                } else {
                    print("Error가 발생하였습니다.")
                }
            }
        
    }
    
    func getDefaultsLocations() {
        Defaults.locations.removeAll()
        self.locationRespository.getAll().forEach { location in
            Defaults.locations.append(location)
            self.coordinator.presentMainView()
        }
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
                    self.onCompleteSetCurrentLocation.send(completion: .finished)
                } complete: { [weak self] in
                    guard let self = self else { return }
                }
        } error: {[weak self] err in
            print("err!!: \(err)")
            self?.onCompleteSetCurrentLocation.send(false)
        }
    }
}
