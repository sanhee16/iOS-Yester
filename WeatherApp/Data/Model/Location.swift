//
//  Location.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/17.
//

import Foundation

struct Location: Equatable, Hashable, Codable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.lat == rhs.lat && lhs.lon == rhs.lon
    }
    var uuid: String = UUID().uuidString
    var lat: Double // 위도
    var lon: Double // 경도
    var isStar: Bool // 즐겨찾기
    var isCurrent: Bool // 현재 위치
    var name: String
}
