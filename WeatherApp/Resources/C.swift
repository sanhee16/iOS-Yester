//
//  C.swift
//  WeatherApp
//
//  Created by sandy on 2023/08/22.
//

import Foundation

enum DevMode {
    case release
    case develop
}

final class C {
    static var weatherUnit: WeatherUnit = .metric
    static var lastUpdate: Int? = nil
    
    static var devMode: DevMode = .develop
}
