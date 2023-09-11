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
    func onClickDelete(_ location: Location)
    func onClickAdd()
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
        self.locations.value = Defaults.locations
        self.isLoading.value = false
    }
    
    func onClickAdd() {
        self.coordinator.presentSelectLocation()
    }
    
    func onClickDelete(_ location: Location) {
        if self.isLoading.value {
            return
        }
        self.isLoading.value = true
        self.coordinator.presentAlertView(.yesOrNo(onClickYes: {[weak self] in
            guard let self = self else { return }
            
            try? self.locationRespository.delete(item: location)
            Defaults.locations.removeAll()
            self.locationRespository.getAll().forEach { location in
                Defaults.locations.append(location)
            }
            self.locations.value = Defaults.locations
            self.isLoading.value = false
        }, onClickNo: { [weak self] in
            self?.isLoading.value = false
        }), title: nil, message: "check_delete".localized([location.name]))
    }
}
