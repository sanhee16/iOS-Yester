//
//  C.swift
//  WeatherApp
//
//  Created by sandy on 2023/08/22.
//

import Foundation
import GoogleMobileAds


enum DevMode {
    case release
    case develop
}

final class C {
    static var weatherUnit: WeatherUnit = .metric
    static var lastUpdate: Int? = nil
    static let LOCATION_LIMMIT: Int = 3
    static let INTERSTITIAL_AD_LIMIT: Int = 10
    
    static var devMode: DevMode = .develop
    
}
