//
//  Geocoding.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/19.
//

import Foundation

struct Geocoding: Equatable {
    static func == (lhs: Geocoding, rhs: Geocoding) -> Bool {
        return lhs.lat == rhs.lat && lhs.lon == rhs.lon
    }
    var name: String
    var lat: Double
    var lon: Double
    var country: String
    var localName: String
    var address: String
    
    init(geocoding: GeocodingResponse, reverse: ReverseGeocoding) {
        self.name = geocoding.name
        self.lat = geocoding.lat
        self.lon = geocoding.lon
        self.country = geocoding.country
        self.localName = geocoding.localName
        self.address = reverse.getAddress()
    }
}

// https://openweathermap.org/api/geocoding-api
struct GeocodingResponse: Codable, Equatable {
    static func == (lhs: GeocodingResponse, rhs: GeocodingResponse) -> Bool {
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

// https://nominatim.openstreetmap.org/reverse?format=json&lat=38.09902&lon=128.64915
struct ReverseGeocoding: Codable, Equatable {
    static func == (lhs: ReverseGeocoding, rhs: ReverseGeocoding) -> Bool {
        return lhs.lat == rhs.lat && lhs.lon == rhs.lon
    }
    var lat: String
    var lon: String
    var displayName: String // display_name
    var reverseGeocodingAddress: ReverseGeocodingAddress
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
        case displayName = "display_name"
        case reverseGeocodingAddress = "address"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decode(String.self, forKey: .lat)
        lon = try values.decode(String.self, forKey: .lon)
        displayName = try values.decode(String.self, forKey: .displayName)
        reverseGeocodingAddress = try values.decode(ReverseGeocodingAddress.self, forKey: .reverseGeocodingAddress)
        name = reverseGeocodingAddress.city ?? reverseGeocodingAddress.state ?? reverseGeocodingAddress.county ?? reverseGeocodingAddress.village ?? reverseGeocodingAddress.country
    }
    
    func getAddress() -> String {
        let displayNameArr = self.displayName.components(separatedBy: ", ")
        let addressArr = reverseGeocodingAddress.arr
        var result: String = ""
        for displayUnit in displayNameArr {
            if addressArr.contains(where: { str in
                str == displayUnit
            }) {
                result.append(displayUnit + " ")
            }
        }
        return result
    }
}

struct ReverseGeocodingAddress: Codable, Equatable {
    var village: String?
    var county: String?
    var province: String?
    var city: String?
    var state: String?
    var country: String //common
    var arr: [String?]
    
    enum CodingKeys: String, CodingKey {
        case village
        case county
        case province
        case city
        case state
        case country
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        village = try values.decodeIfPresent(String.self, forKey: .village)
        county = try values.decodeIfPresent(String.self, forKey: .county)
        province = try values.decodeIfPresent(String.self, forKey: .province)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        country = try values.decode(String.self, forKey: .country)
        arr = [village, county, province, city, state, country]
    }
}
