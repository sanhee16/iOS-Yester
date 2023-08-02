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
    let locationService: LocationService
    
    private init() {
        self.locationRespository = AnyRepository()
        print("base url: \(AppConfiguration().WeatherApiBaseURL)")
        print("apiKey: \(AppConfiguration().WeatherApiKey)")
        self.weatherService = WeatherService(
            baseUrl: AppConfiguration().WeatherApiBaseURL,
            apiKey: AppConfiguration().WeatherApiKey
        )
        self.locationService = LocationService()
    }
}
