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



extension WeatherInfo {
    func iconImage(_ size: CGFloat) -> UIImage? {
        guard let icon = self.weather.first?.icon else { return nil }
        return UIImage(named: icon)?.resized(toWidth: size)
    }
    
    func iconImageSecond(_ size: CGFloat) -> UIImage? {
        if self.weather.count < 2 { return nil }
        return UIImage(named: self.weather[1].icon)?.resized(toWidth: size)
    }
    
    func getDescription(_ idx: Int) -> String {
        if self.weather.count <= idx { return "" }
        switch self.weather[idx].id {
        case 200: return "thunderstorm with light rain".localized()
        case 201: return "thunderstorm with rain".localized()
        case 202: return "thunderstorm with heavy rain".localized()
        case 210: return "light thunderstorm".localized()
        case 211: return "thunderstorm".localized()
        case 212: return "heavy thunderstorm".localized()
        case 221: return "ragged thunderstorm".localized()
        case 230: return "thunderstorm with light drizzle".localized()
        case 231: return "thunderstorm with drizzle".localized()
        case 232: return "thunderstorm with heavy drizzle".localized()
        case 300: return "light intensity drizzle".localized()
        case 301: return "drizzle".localized()
        case 302: return "heavy intensity drizzle".localized()
        case 310: return "light intensity drizzle rain".localized()
        case 311: return "drizzle rain".localized()
        case 312: return "heavy intensity drizzle rain".localized()
        case 313: return "shower rain and drizzle".localized()
        case 314: return "heavy shower rain and drizzle".localized()
        case 321: return "shower drizzle".localized()
        case 500: return "light rain".localized()
        case 501: return "moderate rain".localized()
        case 502: return "heavy intensity rain".localized()
        case 503: return "very heavy rain".localized()
        case 504: return "extreme rain".localized()
        case 511: return "freezing rain".localized()
        case 520: return "light intensity shower rain".localized()
        case 521: return "shower rain".localized()
        case 522: return "heavy intensity shower rain".localized()
        case 531: return "ragged shower rain".localized()
        case 600: return "light snow".localized()
        case 601: return "snow".localized()
        case 602: return "heavy snow".localized()
        case 611: return "sleet".localized()
        case 612: return "light shower sleet".localized()
        case 613: return "shower sleet".localized()
        case 615: return "light rain and snow".localized()
        case 616: return "rain and snow".localized()
        case 620: return "light shower snow".localized()
        case 621: return "shower snow".localized()
        case 622: return "heavy shower snow".localized()
        case 701: return "mist".localized()
        case 711: return "smoke".localized()
        case 721: return "haze".localized()
        case 731: return "sand/dust whirls".localized()
        case 741: return "fog".localized()
        case 751: return "sand".localized()
        case 761: return "dust".localized()
        case 762: return "volcanic ash".localized()
        case 771: return "squalls".localized()
        case 781: return "tornado".localized()
        case 800: return "clear sky".localized()
        case 801: return "few clouds".localized()
        case 802: return "scattered clouds".localized()
        case 803: return "broken clouds".localized()
        case 804: return "overcast clouds".localized()
        default: return ""
        }
    }
}
