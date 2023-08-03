//
//  MainView.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/11.
//

import Foundation
import Combine


protocol MainViewModel: MainViewModelInput, MainViewModelOutput { }

protocol MainViewModelInput {
    func viewWillAppear()
    func onClickAddLocation()
    func onClickDelete(item: Location)
    func onClickStar(item: Location)
}

protocol MainViewModelOutput {
    var locations: Observable<[Location]> { get }
}

class DefaultMainViewModel: BaseViewModel {
    private let locationRespository: AnyRepository<Location>
    var locations: Observable<[Location]> = Observable([])

    init(_ coordinator: AppCoordinator, locationRespository: AnyRepository<Location>) {
        self.locationRespository = locationRespository
        super.init(coordinator)
    }
    
    func getLocations() {
        locations.value = locationRespository.getAll()
    }
}

extension DefaultMainViewModel: MainViewModel {
    func viewWillAppear() {
        self.getLocations()
    }
    
    func onClickAddLocation() {
        coordinator.presentSelectLocation()
    }
    
    func onClickStar(item: Location) {
        let updateItem = Location(lat: item.lat, lon: item.lon, isStar: !item.isStar, isCurrent: item.isCurrent)
        try? self.locationRespository.update(item: updateItem)
        self.getLocations()
    }
    
    func onClickDelete(item: Location) {
        try? self.locationRespository.delete(item: item)
        self.getLocations()
    }
}
