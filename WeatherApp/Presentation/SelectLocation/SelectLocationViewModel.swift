//
//  SelectLocationViewModel.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/18.
//

import Foundation
import Combine
import Alamofire
import CoreLocation

protocol SelectLocationViewModel: SelectLocationViewModelInput, SelectLocationViewModelOutput { }

protocol SelectLocationViewModelInput {
    var name: Observable<String> { get }
    func viewWillAppear()
    func viewDidLoad()
    func onClickSearch()
    func onClickSearchMyLocation()
}

protocol SelectLocationViewModelOutput {
    var results: Observable<[Geocoding]> { get }
    var isSearching: Observable<Bool> { get }
}

class DefaultSelectLocationViewModel: BaseViewModel, SelectLocationViewModel {
    func viewWillAppear() {
        
    }
    
    func viewDidLoad() {
        
    }
        
    var results: Observable<[Geocoding]> = Observable([])
    let weatherService: WeatherService
    let locationService: LocationService
    var name: Observable<String> = Observable("")
    var isSearching: Observable<Bool> = Observable(false)
    
    func onClickSearch() {
        self.isSearching.value = true
        self.weatherService.getGeocoding(name.value)
            .run(in: &self.subscription) {[weak self] response in
                guard let self = self else { return }
                self.results.value = response.value ?? []
//                print("success: \(response.value)")
//                print("error?: \(response.error)")
            } complete: {[weak self] in
                guard let self = self else { return }
                self.isSearching.value = false
                print("complete")
            }
    }
    
    func onClickSearchMyLocation() {
        self.locationService.requestLocation {[weak self] coordinate in
            guard let self = self else { return }
            self.isSearching.value = true
            //좌표 값을 수신한 경우 fetchWeatherData를 통해서 api 호출
            self.weatherService.getReverseGeocoding(coordinate)
                .run(in: &self.subscription) { [weak self] response in
                    guard let self = self else { return }
                    self.results.value = response.value ?? []
                } complete: {[weak self] in
                    guard let self = self else { return }
                    self.isSearching.value = false
                }
        }
    }
    
    let locationRespository: AnyRepository<Location>

    init(_ coordinator: AppCoordinator, locationRespository: AnyRepository<Location>, weatherService: WeatherService, locationService: LocationService) {
        self.locationRespository = locationRespository
        self.weatherService = weatherService
        self.locationService = locationService
        super.init(coordinator)
    }
}
