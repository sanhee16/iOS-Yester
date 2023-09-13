//
//  AppConfig.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/22.
//

import Foundation

final class AppConfiguration {
    lazy var WeatherApiKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "WeatherApiKey") as? String else {
            fatalError("Weather ApiKey must not be empty in plist")
        }
        return apiKey
    }()
    
    lazy var WeatherApiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "WeatherApiUrl") as? String else {
            fatalError("Weather ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
    
    lazy var WeatherApiKeyV2: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "WeatherApiKeyV2") as? String else {
            fatalError("Weather ApiKey must not be empty in plist")
        }
        return apiKey
    }()
    
    lazy var WeatherApiBaseURLV2: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "WeatherApiUrlV2") as? String else {
            fatalError("Weather ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
    
    lazy var ReverseGeocodingBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ReverseGeocodingUrl") as? String else {
            fatalError("Reverse Geocoding ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
}
