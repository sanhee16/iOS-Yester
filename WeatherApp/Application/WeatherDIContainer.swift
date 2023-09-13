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
            baseUrl: AppConfiguration().WeatherApiBaseURL,
            apiKey: AppConfiguration().WeatherApiKey
        )
        self.weatherServiceV2 = WeatherServiceV2(
            baseUrl: AppConfiguration().WeatherApiBaseURLV2,
            apiKey: AppConfiguration().WeatherApiKeyV2
        )
        self.locationService = LocationService()
        self.geocodingService = GeocodingService(geocodingUrl: AppConfiguration().WeatherApiBaseURL, reverseGeocodingUrl: AppConfiguration().ReverseGeocodingBaseURL, apiKey: AppConfiguration().WeatherApiKey)
    }
}
