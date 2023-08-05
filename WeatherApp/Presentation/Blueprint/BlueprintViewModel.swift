//
//  BlueprintViewModel.swift
//  WeatherApp
//
//  Created by sandy on 2023/08/04.
//

import Foundation
import Combine
import Alamofire
import CoreLocation

protocol BlueprintViewModel: BlueprintViewModelInput, BlueprintViewModelOutput { }

protocol BlueprintViewModelInput {
    var name: Observable<String> { get }
    func viewWillAppear()
    func viewDidLoad()
}

protocol BlueprintViewModelOutput {
    var sample: Observable<[String]> { get }
}

class DefaultBlueprintViewModel: BaseViewModel, BlueprintViewModel {
    let weatherService: WeatherService
    let locationService: LocationService
    let locationRespository: AnyRepository<Location>
    
    var sample: Observable<[String]> = Observable([])
    var name: Observable<String> = Observable("")
    
    init(_ coordinator: AppCoordinator, locationRespository: AnyRepository<Location>, weatherService: WeatherService, locationService: LocationService) {
        self.locationRespository = locationRespository
        self.weatherService = weatherService
        self.locationService = locationService
        super.init(coordinator)
    }
    
    func viewWillAppear() {
        
    }
    
    func viewDidLoad() {
        
    }
}
