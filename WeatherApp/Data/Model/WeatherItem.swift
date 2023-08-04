//
//  WeatherItem.swift
//  WeatherApp
//
//  Created by sandy on 2023/08/03.
//

import Foundation

struct WeatherItem: Equatable {
    static func == (lhs: WeatherItem, rhs: WeatherItem) -> Bool {
        return lhs.location == rhs.location
    }
    var location: Location
    var currentWeather: Current?
    var dailyWeather: [Daily]
    var ThreeHourly: [ThreeHourly]
    var isLoaded: Bool
}
