//
//  LocationRepository.swift
//  WeatherApp
//
//  Created by sandy on 2023/09/30.
//

import Foundation


class LocationRepository: AnyRepository<Location> {
    func updateCurrentLocation(lat: Double, lon: Double, name: String, address: String) {
        if self.getAll(where: NSPredicate(format: "isCurrent == true")).count > 0 {
            var currentItem = self.getAll(where: NSPredicate(format: "isCurrent == true")).first!
            currentItem.lat = lat
            currentItem.lon = lon
            currentItem.name = name
            currentItem.address = address
            try? self.update(item: currentItem)
        } else {
            let location = Location(lat: lat, lon: lon, isStar: false, isCurrent: true, name: name, address: address)
            try? self.insert(item: location)
        }

    }
}
