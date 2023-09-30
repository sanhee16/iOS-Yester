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
    func onClickDeleteAll()
    func onClickAdd()
}

protocol ManageLocationViewModelOutput {
    var isLoading: Observable<Bool> { get }
    var locations: Observable<[Location]> { get }
}

class DefaultManageLocationViewModel: BaseViewModel {
    private let locationRepository: LocationRepository
    private let locationService: LocationService
    
    var locations: Observable<[Location]> = Observable([])
    var isLoading: Observable<Bool> = Observable(false)
    
    init(_ coordinator: AppCoordinator, locationRepository: LocationRepository, locationService: LocationService) {
        self.locationRepository = locationRepository
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
            
            try? self.locationRepository.delete(item: location)
            Defaults.locations.removeAll()
            self.locationRepository.getAll().forEach { location in
                Defaults.locations.append(location)
            }
            self.locations.value = Defaults.locations
            self.isLoading.value = false
        }, onClickNo: { [weak self] in
            self?.isLoading.value = false
        }), title: nil, message: "check_delete".localized([location.name]))
    }
    
    func onClickDeleteAll() {
        if self.isLoading.value {
            return
        }
        self.isLoading.value = true
        self.coordinator.presentAlertView(.yesOrNo(onClickYes: {[weak self] in
            guard let self = self else { return }
            
            let deleteList = self.locationRepository.getAll(where: NSPredicate(format: "isCurrent == false"))
            for deleteItem in deleteList {
                try? self.locationRepository.delete(item: deleteItem)
            }
            Defaults.locations.removeAll()
            self.locationRepository.getAll().forEach { location in
                Defaults.locations.append(location)
            }
            self.locations.value = Defaults.locations
            self.isLoading.value = false
        }, onClickNo: { [weak self] in
            self?.isLoading.value = false
        }), title: nil, message: "check_delete_all".localized())
    }
}
