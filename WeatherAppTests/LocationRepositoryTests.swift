//
//  LocationRepositoryTests.swift
//  WeatherAppTests
//
//  Created by sandy on 2023/10/02.
//

import XCTest
@testable import WeatherApp

final class LocationRepositoryTests: XCTestCase {
    var sut: LocationRepository! = nil
    
    override func setUpWithError() throws {
        print("[TEST] setUpWithError")
        sut = LocationRepository()
        try? sut.deleteAll()
    }

    override func tearDownWithError() throws {
        print("[TEST] tearDownWithError")
        print("[TEST] --------------")
        try? sut.deleteAll()
        sut = nil
    }
    
    // Current Location이 없을 때 추가하기
    func test_whenCurrentNotExist_shouldAddCurrent() {
        print("[TEST] test_whenCurrentNotExist_shouldAddCurrent")
        
        sut.updateCurrentLocation(lat: 1.0, lon: 2.0, name: "Current Location", address: "Current Address")
        let currentItem = sut.getAll(where: NSPredicate(format: "isCurrent == true")).first
        
        XCTAssertNotNil(currentItem, "current update successfully")
    }
    
    // Current Location이 있을 때 Current Location 업데이트 하기
    func test_whenCurrentExist_shouldUpdateCurrent() {
        print("[TEST] test_whenCurrentExist_shouldUpdateCurrent")
        
        sut.updateCurrentLocation(lat: 1.0, lon: 2.0, name: "Current Location", address: "Current Address")
        sut.updateCurrentLocation(lat: 10.0, lon: 20.0, name: "Update Current Location", address: "Update Current Address")
        let currentItem = sut.getAll(where: NSPredicate(format: "isCurrent == true")).first
        
        XCTAssertTrue(currentItem?.name == "Update Current Location", "current update successfully")
    }
}
