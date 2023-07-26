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
}
