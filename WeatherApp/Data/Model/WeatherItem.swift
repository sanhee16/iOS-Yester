//
//  WeatherItem.swift
//  WeatherApp
//
//  Created by sandy on 2023/08/03.
//

import Foundation

struct WeatherCardItem: Equatable {
    static func == (lhs: WeatherCardItem, rhs: WeatherCardItem) -> Bool {
        return lhs.location == rhs.location
    }
    var location: Location
    var currentWeather: Current?
    var daily: [DailyWeather]
    var hourly: [HourlyWeather]
    var threeHourly: [ThreeHourly]
    var isLoaded: Bool
}
