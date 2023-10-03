//
//  ManageLocationViewModelTests.swift
//  WeatherAppTests
//
//  Created by sandy on 2023/10/03.
//

import XCTest
@testable import WeatherApp

final class ManageLocationViewModelTests: XCTestCase {
    var sut: DefaultManageLocationViewModel! = nil
    
    override func setUpWithError() throws {
        print("[TEST] setUpWithError")
        
        let appCoordinator = AppCoordinator(navigationController: UINavigationController())
        let locationRepository = LocationRepository()
        let locationService = LocationService()
        
        sut = DefaultManageLocationViewModel(
            appCoordinator,
            locationRepository: locationRepository,
            locationService: locationService
        )
        Defaults.locations.removeAll()
        
        print("[TEST] userDefaults: \(Defaults.locations)")
        print("[TEST] userDefaults: \(Defaults.weatherUnit)")
    }
    
    override func tearDownWithError() throws {
        print("[TEST] tearDownWithError")
        print("[TEST] --------------")
        sut = nil
    }
    
    func test_whenDeleteList_shouldUserDefaultsDeleteList() {
        print("[TEST] test_whenDeleteList_shouldUserDefaultsDeleteList")
        insertDummy()
        sut.deleteListAndUpdateDefaults(sut.locationRepository.getAll())
        XCTAssertTrue(Defaults.locations.isEmpty, "Defaults.locations erased All successfully")
    }
    
    func test_whenDeleteItem_shouldUserDefaultsDeleteItem() {
        print("[TEST] test_whenDeleteItem_shouldUserDefaultsDeleteItem")
        insertDummy()
        
        let lastItem = sut.locationRepository.getAll().last!
        sut.deleteListAndUpdateDefaults([lastItem])
        
        
        
        let defaults = Defaults.locations.filter {
            $0.uuid == lastItem.uuid
        }
        XCTAssertTrue(defaults.isEmpty, "Defaults.locations erase item successfully")
    }
    
    private func insertDummy() {
        print("[TEST] insertDummy")
        try? sut.locationRepository.deleteAll()
        try? sut.locationRepository.insert(item: Location(lat: 0.0, lon: 0.0, isStar: false, isCurrent: true, name: "current", address: "current Address"))
        try? sut.locationRepository.insert(item: Location(lat: 1.0, lon: 1.0, isStar: false, isCurrent: true, name: "item1", address: "item1 Address"))
        try? sut.locationRepository.insert(item: Location(lat: 2.0, lon: 2.0, isStar: false, isCurrent: true, name: "item2", address: "item2 Address"))
        try? sut.locationRepository.insert(item: Location(lat: 3.0, lon: 3.0, isStar: false, isCurrent: true, name: "item3", address: "item3 Address"))
    }
}
