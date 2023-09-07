//
//  ManageLocationViewModel.swift
//  WeatherApp
//
//  Created by sandy on 2023/09/06.
//

import Foundation
import Alamofire
import Combine


protocol ManageLocationViewModel: ManageLocationViewModelInput, ManageLocationViewModelOutput { }

protocol ManageLocationViewModelInput {
    func viewWillAppear()
    func viewDidLoad()
    func onClickDelete()
}

protocol ManageLocationViewModelOutput {
    var isLoading: Observable<Bool> { get }
    var locations: Observable<[Location]> { get }
}

class DefaultManageLocationViewModel: BaseViewModel {
    private let locationRespository: AnyRepository<Location>
    private let locationService: LocationService
    
    var locations: Observable<[Location]> = Observable([])
    var isLoading: Observable<Bool> = Observable(false)
    
    init(_ coordinator: AppCoordinator, locationRespository: AnyRepository<Location>, locationService: LocationService) {
        self.locationRespository = locationRespository
        self.locationService = locationService
        super.init(coordinator)
    }
}

extension DefaultManageLocationViewModel: ManageLocationViewModel {
    func viewDidLoad() {
        
    }
    
    func viewWillAppear() {
        self.isLoading.value = false
        self.locations.value = Defaults.locations
    }
    
    func deleteLocation() {
        
    }
    
    func onClickAddLocation() {
        
    }
    
    func onClickDelete() {
        
    }
}
