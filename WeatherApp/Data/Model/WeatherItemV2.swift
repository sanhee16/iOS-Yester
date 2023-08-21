//
//  WeatherItemV2.swift
//  WeatherApp
//
//  Created by sandy on 2023/08/21.
//

import Foundation

struct WeatherCardItemV2: Equatable {
    static func == (lhs: WeatherCardItemV2, rhs: WeatherCardItemV2) -> Bool {
        return lhs.location == rhs.location
    }
    var location: Location
    var currentWeather: CurrentV2?
    var history: ForecastV2?
    var forecast: [ForecastV2]
    var isLoaded: Bool
}
