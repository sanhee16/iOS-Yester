//
//  WeatherData.swift
//  WeatherApp
//
//  Created by sandy on 2023/08/03.
//

import Foundation
import UIKit

enum WeatherType: Int {
    case clearSky = 0
    case fewClouds = 1
    case scatteredClouds = 2
    case brokenClouds = 3
    case showerRain = 4
    case rain = 5
    case thunderStorm = 6
    case snow = 7
    case mist = 8
    case unknown = 9
    
    
    var uiColor: UIColor {
        switch self {
        case .clearSky: return .clearSky60
        case .fewClouds: return .fewClouds60
        case .scatteredClouds: return .scatteredClouds60
        case .brokenClouds: return .brokenClouds60
        case .showerRain: return .showerRain60
        case .rain: return .rain60
        case .thunderStorm: return .thunderStorm60
        case .snow: return .snow60
        case .mist: return .mist60
        case .unknown: return .unknown60
        }
    }
}

enum WeatherDetail {
    case feelLike
    case windSpeed
    case pressure
    case humidity
    case uv
    case cloud
    
    var name: String {
        switch self {
        case .feelLike: return "체감온도"
        case .windSpeed: return "풍속"
        case .pressure: return "기압"
        case .humidity: return "습도"
        case .uv: return "자외선"
        case .cloud: return "흐림 정도"
        }
    }
}

extension String {
    func weatherType() -> WeatherType {
        switch self {
        case "01d","01n": return .clearSky
        case "02d","02n": return .fewClouds
        case "03d","03n": return .scatteredClouds
        case "04d","04n": return .brokenClouds
        case "09d","09n": return .showerRain
        case "10d","10n": return .rain
        case "11d","11n": return .thunderStorm
        case "13d","13n": return .snow
        case "50d","50n": return .mist
        default: return .unknown
        }
    }
}

extension Int {
    func uviText() -> String {
        switch self {
        case ..<3: return "low_uv".localized()
        case 3..<6: return "normal_uv".localized()
        case 6..<8: return "high_uv".localized()
        case 8..<11: return "very_high_uv".localized()
        default: return "dangerous_uv".localized()
        }
    }
}

enum WeatherUnit: Int {
    case metric = 0
    case imperial = 1
    
    var apiUnits: String {
        switch self {
        case .metric: return "metric"
        case .imperial: return "imperial"
        }
    }
    
    var unitText: String {
        switch self {
        case .metric: return "metric".localized()
        case .imperial: return "imperial".localized()
        }
    }
    
    var tempUnit: String {
        switch self {
        case .metric: return "°"
        case .imperial: return "°"
        }
    }
    
    var windUnit: String {
        switch self {
        case .metric: return "m/s"
        case .imperial: return "mph"
        }
    }
    
    var tempDescription: String {
        switch self {
        case .metric: return "celsius".localized()
        case .imperial: return "fahrenheit".localized()
        }
    }
    
    var windDescription: String {
        switch self {
        case .metric: return "meter/sec (m/s)"
        case .imperial: return "miles/hour (mph)"
        }
    }
}
