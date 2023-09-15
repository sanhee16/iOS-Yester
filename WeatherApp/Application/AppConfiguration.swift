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
    
    lazy var GADBannerID: String = {
        guard let bannerID = Bundle.main.object(forInfoDictionaryKey: "GADBannerID") as? String else {
            fatalError("Reverse Geocoding GADBannerID must not be empty in plist")
        }
        // testID: ca-app-pub-3940256099942544/2934735716
        return bannerID
    }()
    
    lazy var GADInterstitialID: String = {
        guard let interstitialID = Bundle.main.object(forInfoDictionaryKey: "GADInterstitialID") as? String else {
            fatalError("Reverse Geocoding GADInterstitialID must not be empty in plist")
        }
        // testID: ca-app-pub-3940256099942544/2934735716
        return interstitialID
    }()
    
    lazy var GADMainBannerID: String = {
        guard let bannerID = Bundle.main.object(forInfoDictionaryKey: "GADMainBannerID") as? String else {
            fatalError("Reverse Geocoding GADMainBannerID must not be empty in plist")
        }
        // testID: ca-app-pub-3940256099942544/2934735716
        return bannerID
    }()
    
}
