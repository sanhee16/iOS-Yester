//
//  Geocoding.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/19.
//

import Foundation

/*
 [
     {
         "name": "Yongin-si",
         "local_names": {
             "de": "Yongin",
             "pt": "Yongin",
             "ascii": "Yongin",
             "ja": "竜仁市",
             "ru": "Йонъин",
             "en": "Yongin-si",
             "es": "Yongin",
             "ca": "Yongin",
             "feature_name": "Yongin",
             "et": "Yongin",
             "fr": "Yongin",
             "ko": "용인시",
             "zh": "龍仁市"
         },
         "lat": 37.2405741,
         "lon": 127.1785572,
         "country": "KR"
         "state":"England"
 }
 ]
 */

// https://openweathermap.org/api/geocoding-api
struct Geocoding: Codable, Equatable {
    static func == (lhs: Geocoding, rhs: Geocoding) -> Bool {
        return lhs.lat == rhs.lat && lhs.lon == rhs.lon
    }
    var name: String
    var lat: Double
    var lon: Double
    var country: String
    var localNames: [String: String]
    var state: String?
    var localName: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case lat
        case lon
        case country
        case localNames = "local_names"
        case state
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        lat = try values.decode(Double.self, forKey: .lat)
        lon = try values.decode(Double.self, forKey: .lon)
        country = try values.decode(String.self, forKey: .country).localizedCountryName()
        localNames = try values.decodeIfPresent([String: String].self, forKey: .localNames) ?? [:]
        state = try values.decodeIfPresent(String.self, forKey: .state)
        localName = localNames[Utils.languageCode()] ?? name
    }
}

struct LocalName: Codable {
    var ko: String?
    var en: String?
    var ja: String?
    
    enum CodingKeys: String, CodingKey {
        case ko
        case en
        case ja
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ko = try values.decodeIfPresent(String.self, forKey: .ko)
        en = try values.decodeIfPresent(String.self, forKey: .en)
        ja = try values.decodeIfPresent(String.self, forKey: .ja)
    }
}
