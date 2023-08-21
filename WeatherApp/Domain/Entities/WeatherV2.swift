//
//  WeatherV2.swift
//  WeatherApp
//
//  Created by sandy on 2023/08/21.
//

import Foundation
import UIKit

// Common
public struct ConditionV2: Codable {
    var text: String
    var icon: String
    var code: Int
    
    enum CodingKeys: String, CodingKey {
        case text
        case icon
        case code
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text = try values.decode(String.self, forKey: .text)
        icon = try values.decode(String.self, forKey: .icon)
        code = try values.decode(Int.self, forKey: .code)
    }
}



// Current
public struct CurrentResponseV2: Codable {
    var current: CurrentV2
    var forecast: ForecastListV2
    
    enum CodingKeys: String, CodingKey {
        case current
        case forecast
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        current = try values.decode(CurrentV2.self, forKey: .current)
        forecast = try values.decode(ForecastListV2.self, forKey: .forecast)
    }
}

public struct CurrentV2: Codable {
    var temp_c: Double
    var temp_f: Double
    var condition: ConditionV2
    var feelslike_c: Double
    var feelslike_f: Double
    var wind_mph: Double
    var wind_kph: Double
    var precip_mm: Double
    var precip_in: Double
    var uv: Int
    var humidity: Int
    var cloud: Int
    var is_day: Bool
    
    enum CodingKeys: String, CodingKey {
        case temp_c
        case temp_f
        case condition
        case feelslike_c
        case feelslike_f
        case wind_mph
        case wind_kph
        case precip_mm
        case precip_in
        case uv
        case humidity
        case cloud
        case is_day
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        temp_c = try values.decode(Double.self, forKey: .temp_c)
        temp_f = try values.decode(Double.self, forKey: .temp_f)
        condition = try values.decode(ConditionV2.self, forKey: .condition)
        feelslike_c = try values.decode(Double.self, forKey: .feelslike_c)
        feelslike_f = try values.decode(Double.self, forKey: .feelslike_f)
        wind_mph = try values.decode(Double.self, forKey: .wind_mph)
        wind_kph = try values.decode(Double.self, forKey: .wind_kph)
        precip_mm = try values.decode(Double.self, forKey: .precip_mm)
        precip_in = try values.decode(Double.self, forKey: .precip_in)
        uv = try values.decode(Int.self, forKey: .uv)
        humidity = try values.decode(Int.self, forKey: .humidity)
        cloud = try values.decode(Int.self, forKey: .cloud)
        is_day = try values.decode(Bool.self, forKey: .is_day)
    }
}

// Forecast
public struct ForecastResponseV2: Codable {
    var forecast: ForecastListV2
    
    enum CodingKeys: String, CodingKey {
        case forecast
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        forecast = try values.decode(ForecastListV2.self, forKey: .forecast)
    }
}

public struct ForecastListV2: Codable {
    var forecastday: [ForecastV2]
    
    enum CodingKeys: String, CodingKey {
        case forecastday
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        forecastday = try values.decode([ForecastV2].self, forKey: .forecastday)
    }
}

public struct ForecastV2: Codable {
    var day: ForecastDayV2
    var astro: ForecastAstroV2
    var hour: ForecastHourV2
    
    enum CodingKeys: String, CodingKey {
        case day
        case astro
        case hour
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        day = try values.decode(ForecastDayV2.self, forKey: .day)
        astro = try values.decode(ForecastAstroV2.self, forKey: .astro)
        hour = try values.decode(ForecastHourV2.self, forKey: .hour)
    }
}


public struct ForecastHourV2: Codable {
    var time_epoch: Int
    var temp_c: Double
    var temp_f: Double
    var is_day: Bool
    var condition: ConditionV2
    var precip_mm: Double
    var precip_in: Double
    var humidity: Int
    var cloud: Int
    
    enum CodingKeys: String, CodingKey {
        case time_epoch
        case temp_c
        case temp_f
        case is_day
        case condition
        case precip_mm
        case precip_in
        case humidity
        case cloud
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        time_epoch = try values.decode(Int.self, forKey: .time_epoch)
        temp_c = try values.decode(Double.self, forKey: .temp_c)
        temp_f = try values.decode(Double.self, forKey: .temp_f)
        is_day = try values.decode(Bool.self, forKey: .is_day)
        condition = try values.decode(ConditionV2.self, forKey: .condition)
        precip_mm = try values.decode(Double.self, forKey: .precip_mm)
        precip_in = try values.decode(Double.self, forKey: .precip_in)
        humidity = try values.decode(Int.self, forKey: .humidity)
        cloud = try values.decode(Int.self, forKey: .cloud)
    }
}

public struct ForecastDayV2: Codable {
    var maxtemp_c: Double
    var maxtemp_f: Double
    var mintemp_c: Double
    var mintemp_f: Double
    var condition: ConditionV2
    
    
    enum CodingKeys: String, CodingKey {
        case maxtemp_c
        case maxtemp_f
        case mintemp_c
        case mintemp_f
        case condition
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        maxtemp_c = try values.decode(Double.self, forKey: .maxtemp_c)
        maxtemp_f = try values.decode(Double.self, forKey: .maxtemp_f)
        mintemp_c = try values.decode(Double.self, forKey: .mintemp_c)
        mintemp_f = try values.decode(Double.self, forKey: .mintemp_f)
        condition = try values.decode(ConditionV2.self, forKey: .condition)
    }
}

public struct ForecastAstroV2: Codable {
    var sunrise: String
    var sunset: String
    
    
    enum CodingKeys: String, CodingKey {
        case sunrise
        case sunset
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sunrise = try values.decode(String.self, forKey: .sunrise)
        sunset = try values.decode(String.self, forKey: .sunset)
    }
}

extension CurrentV2 {
    func iconImage() -> UIImage? {
        let code = self.condition.code
        var iconCode = ""
        switch code {
        case 1000: iconCode = "113"
        case 1003: iconCode = "116"
        case 1006: iconCode = "119"
        case 1009: iconCode = "122"
        case 1030: iconCode = "143"
        case 1063: iconCode = "176"
        case 1066: iconCode = "179"
        case 1069: iconCode = "182"
        case 1072: iconCode = "185"
        case 1087: iconCode = "200"
        case 1114: iconCode = "227"
        case 1117: iconCode = "230"
        case 1135: iconCode = "248"
        case 1147: iconCode = "260"
        case 1150: iconCode = "263"
        case 1153: iconCode = "266"
        case 1168: iconCode = "281"
        case 1171: iconCode = "284"
        case 1180: iconCode = "293"
        case 1183: iconCode = "296"
        case 1186: iconCode = "299"
        case 1189: iconCode = "302"
        case 1192: iconCode = "305"
        case 1195: iconCode = "308"
        case 1198: iconCode = "311"
        case 1201: iconCode = "314"
        case 1204: iconCode = "317"
        case 1207: iconCode = "320"
        case 1210: iconCode = "323"
        case 1213: iconCode = "326"
        case 1216: iconCode = "329"
        case 1219: iconCode = "332"
        case 1222: iconCode = "335"
        case 1225: iconCode = "338"
        case 1237: iconCode = "350"
        case 1240: iconCode = "353"
        case 1243: iconCode = "356"
        case 1246: iconCode = "359"
        case 1249: iconCode = "362"
        case 1252: iconCode = "365"
        case 1255: iconCode = "368"
        case 1258: iconCode = "371"
        case 1261: iconCode = "374"
        case 1264: iconCode = "377"
        case 1273: iconCode = "386"
        case 1276: iconCode = "389"
        case 1279: iconCode = "392"
        case 1282: iconCode = "395"
        default: iconCode = "113"
        }
        
        
        
        var imageCode = ""
        switch iconCode {
        case "113": imageCode = "01"
        case "116": imageCode = "02"
        case "119": imageCode = "03"
        case "122": imageCode = "04"
        case "143": imageCode = "50"
        case "176": imageCode = "20"
        case "179": imageCode = "21"
        case "182": imageCode = "22"
        case "185": imageCode = "09"
        case "200": imageCode = "11"
        case "227": imageCode = "21"
        case "230": imageCode = "21"
        case "248": imageCode = "50"
        case "260": imageCode = "50"
        case "263": imageCode = "09"
        case "266": imageCode = "09"
        case "281": imageCode = "09"
        case "284": imageCode = "09"
        case "293": imageCode = "20"
        case "296": imageCode = "20"
        case "299": imageCode = "20"
        case "302": imageCode = "20"
        case "305": imageCode = "09"
        case "308": imageCode = "09"
        case "311": imageCode = "09"
        case "314": imageCode = "09"
        case "317": imageCode = "22"
        case "320": imageCode = "22"
        case "323": imageCode = "21"
        case "326": imageCode = "21"
        case "329": imageCode = "21"
        case "332": imageCode = "21"
        case "335": imageCode = "23"
        case "338": imageCode = "23"
        case "350": imageCode = "24"
        case "353": imageCode = "20"
        case "356": imageCode = "09"
        case "359": imageCode = "09"
        case "362": imageCode = "22"
        case "365": imageCode = "22"
        case "368": imageCode = "21"
        case "371": imageCode = "23"
        case "374": imageCode = "24"
        case "377": imageCode = "24"
        case "386": imageCode = "11"
        case "389": imageCode = "11"
        case "392": imageCode = "11"
        case "395": imageCode = "11"
        default: imageCode = "01"
        }
        
        imageCode += self.is_day ? "d" : "n"
        return UIImage(named: imageCode)
    }
}
