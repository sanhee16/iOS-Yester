//
//  WeatherDIContainer.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/17.
//

import Foundation
import UIKit

final class AppDIContainer {
    static let shared: AppDIContainer = AppDIContainer()
    let locationRespository: AnyRepository<Location>
    let weatherService: WeatherService
    let weatherServiceV2: WeatherServiceV2
    let locationService: LocationService
    let geocodingService: GeocodingService
    
    private init() {
        self.locationRespository = AnyRepository()
        self.weatherService = WeatherService(
            baseUrl: AppConfiguration.shared.WeatherApiBaseURL,
            apiKey: AppConfiguration.shared.WeatherApiKey
        )
        self.weatherServiceV2 = WeatherServiceV2(
            baseUrl: AppConfiguration.shared.WeatherApiBaseURLV2,
            apiKey: AppConfiguration.shared.WeatherApiKeyV2
        )
        self.locationService = LocationService()
        self.geocodingService = GeocodingService(geocodingUrl: AppConfiguration.shared.WeatherApiBaseURL, reverseGeocodingUrl: AppConfiguration.shared.ReverseGeocodingBaseURL, apiKey: AppConfiguration.shared.WeatherApiKey)
    }
}
