//
//  SelectLocationViewModel.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/18.
//

import Foundation
import Combine
import Alamofire

protocol SelectLocationViewModel: SelectLocationViewModelInput, SelectLocationViewModelOutput { }

protocol SelectLocationViewModelInput {
    var name: Observable<String> { get }
    func viewWillAppear()
    func onClickSearch()
}

protocol SelectLocationViewModelOutput {
    var results: Observable<[Geocoding]> { get }
}

class DefaultSelectLocationViewModel: BaseViewModel, SelectLocationViewModel {
    var results: Observable<[Geocoding]> = Observable([])
    let weatherService: WeatherService
    var name: Observable<String> = Observable("")
    
    func viewWillAppear() {
        
    }
    
    func onClickSearch() {
        self.weatherService.getGeocoding(name.value)
            .run(in: &self.subscription) {[weak self] response in
                guard let self = self else { return }
                print("success: \(response.value)")
                print("error?: \(response.error)")
            } complete: {
                print("complete")
            }
    }
    
    let locationRespository: AnyRepository<Location>

    init(_ coordinator: AppCoordinator, locationRespository: AnyRepository<Location>, weatherService: WeatherService) {
        self.locationRespository = locationRespository
        self.weatherService = weatherService
        super.init(coordinator)
    }
}
