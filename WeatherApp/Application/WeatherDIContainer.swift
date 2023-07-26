//
//  WeatherDIContainer.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/17.
//

import Foundation
import UIKit

final class WeatherDIContainer {
    static let shared: WeatherDIContainer = WeatherDIContainer()
    let locationRespository: AnyRepository<Location>
    let weatherService: WeatherService
    
    private init() {
        self.locationRespository = AnyRepository()
        print("base url: \(AppConfiguration().WeatherApiBaseURL)")
        print("apiKey: \(AppConfiguration().WeatherApiKey)")
        self.weatherService = WeatherService(
            baseUrl: AppConfiguration().WeatherApiBaseURL,
            apiKey: AppConfiguration().WeatherApiKey
        )
    }
}
