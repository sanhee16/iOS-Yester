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
        realmLocation.uuid = uuid
        realmLocation.lat = lat
        realmLocation.lon = lon
        realmLocation.isStar = isStar
        realmLocation.name = name
        realmLocation.isCurrent = isCurrent
        return realmLocation
    }
    
    func toStorable() -> LocationStorage {
        return storableLocation
    }
}

class LocationStorage: Object, Storable {
    @Persisted(primaryKey: true) var uuid: String = ""
    @Persisted var lat: Double = 0.0 // 위도
    @Persisted var lon: Double = 0.0 // 경도
    @Persisted var isStar: Bool = false // 즐겨찾기
    @Persisted var isCurrent: Bool = false // 즐겨찾기
    @Persisted var name: String = "" // local 이름
    
    var model: Location {
        get {
            return Location(uuid: uuid, lat: lat, lon: lon, isStar: isStar, isCurrent: isCurrent, name: name)
        }
    }
}
