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
    func onClickDelete(item: Location)
    func onClickAdd()
    func onClickStar(item: Location)
}

protocol MainViewModelOutput {
    var locations: Observable<[Location]> { get }
}

class DefaultMainViewModel: BaseViewModel, MainViewModel {
    let locationRespository: AnyRepository<Location>
    var locations: Observable<[Location]> = Observable([])

    init(_ coordinator: AppCoordinator, locationRespository: AnyRepository<Location>) {
        self.locationRespository = locationRespository
        super.init(coordinator)
    }
    
    func getLocations() {
        locations.value = locationRespository.getAll()
    }

}

// MARK: Input
extension DefaultMainViewModel {
    func viewWillAppear() {
        self.getLocations()
    }
    
    func onClickDelete(item: Location) {
        try? self.locationRespository.delete(item: item)
        self.getLocations()
    }
    
    func onClickAdd() {
//        let item = Location(lat: Double.random(in: 0.0...125.0), lon: Double.random(in: 0.0...125.0), isStar: false)
//        try? self.locationRespository.insert(item: item)
//        self.getLocations()
        coordinator.presentSelectLocation()
    }
    
    func onClickStar(item: Location) {
        let updateItem = Location(lat: item.lat, lon: item.lon, isStar: !item.isStar)
        try? self.locationRespository.update(item: updateItem)
        self.getLocations()
    }
}
