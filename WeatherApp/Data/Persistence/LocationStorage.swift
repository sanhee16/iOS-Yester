//
//  LocationStorage.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/17.
//

import Foundation
import RealmSwift

extension Location: Entity {
    private var storableLocation: LocationStorage {
        let realmLocation = LocationStorage()
        realmLocation.lat = lat
        realmLocation.lon = lon
        realmLocation.isStar = isStar
        realmLocation.name = name
        realmLocation.isCurrent = isCurrent
        realmLocation.uuid = UUID().uuidString
        return realmLocation
    }
    
    func toStorable() -> LocationStorage {
        return storableLocation
    }
}

class LocationStorage: Object, Storable {
    @objc dynamic var uuid: String = ""
    @objc dynamic var lat: Double = 0.0 // 위도
    @objc dynamic var lon: Double = 0.0 // 경도
    @objc dynamic var isStar: Bool = false // 즐겨찾기
    @objc dynamic var isCurrent: Bool = false // 즐겨찾기
    @objc dynamic var name: String = "" // local 이름
    
    var model: Location {
        get {
            return Location(lat: lat, lon: lon, isStar: isStar, isCurrent: isCurrent, name: name)
        }
    }
}
