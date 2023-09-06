//
//  EditLocationViewModel.swift
//  WeatherApp
//
//  Created by sandy on 2023/09/06.
//

import Foundation
import Alamofire
import Combine


protocol EditLocationViewModel: EditLocationViewModelInput, EditLocationViewModelOutput { }

protocol EditLocationViewModelInput {
    func viewWillAppear()
    func viewDidLoad()
}

protocol EditLocationViewModelOutput {
    var isLoading: Observable<Bool> { get }
}

class DefaultEditLocationViewModel: BaseViewModel {
    private let locationRespository: AnyRepository<Location>
    private let locationService: LocationService
    
    var isLoading: Observable<Bool> = Observable(false)
    
    init(_ coordinator: AppCoordinator, locationRespository: AnyRepository<Location>, locationService: LocationService) {
        self.locationRespository = locationRespository
        self.locationService = locationService
        super.init(coordinator)
    }
}

extension DefaultEditLocationViewModel: EditLocationViewModel {
    func viewDidLoad() { }
    
    func viewWillAppear() {
        self.isLoading.value = false
    }
}
