//
//  Api.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/22.
//

import Foundation
import Alamofire
import Combine
import CoreLocation

protocol WeatherServiceProtocol {
    func getGeocoding(_ name: String) -> AnyPublisher<DataResponse<[Geocoding], NetworkError>, Never>
}

class WeatherService {
    private let baseUrl: String
    private let apiKey: String
    init(baseUrl: String, apiKey: String) {
        self.baseUrl = baseUrl
        self.apiKey = apiKey
    }
}


extension WeatherService: WeatherServiceProtocol {
    private func getData<T: Decodable>(_ url: String, paramters: Parameters? = nil) -> AnyPublisher<DataResponse<T, NetworkError>, Never> {
        let url = URL(string: self.baseUrl + url)!
        var params = paramters
        params?["appid"] = self.apiKey
        return AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default)
            .validate()
            .validate(contentType: ["application/json"])
            .publishDecodable(type: T.self)
            .map { response in
                response.mapError { error in
                    let weatherError = response.data.flatMap { try? JSONDecoder().decode(WeatherError.self, from: $0)}
                    return NetworkError(initialError: error, weatherError: weatherError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func getGeocoding(_ name: String) -> AnyPublisher<DataResponse<[Geocoding], NetworkError>, Never> {
        let params: [String: Any] = [
            "q": name,
            "limit": 10
        ] as Parameters
        return self.getData("geo/1.0/direct", paramters: params)
    }
    
    func getReverseGeocoding(_ coordinate: CLLocationCoordinate2D) -> AnyPublisher<DataResponse<[Geocoding], NetworkError>, Never> {
        let params: [String: Any] = [
            "lat": coordinate.latitude,
            "lon": coordinate.longitude,
            "limit": 10
        ] as Parameters
        return self.getData("geo/1.0/reverse", paramters: params)
    }
    
    func getOneCallWeather(_ location: Location) -> AnyPublisher<DataResponse<WeatherResponse, NetworkError>, Never>{
        let params: [String: Any] = [
            "lat": location.lat,
            "lon": location.lon,
            "exclude": "minutely", // current, minutely, hourly, daily, alerts
            "units": "metric", // standard, metric(섭씨), imperial(화씨)
            "lang": "en"
        ]as Parameters
        return self.getData("data/3.0/onecall", paramters: params)
    }
    
    func get3HourlyWeather(_ location: Location) -> AnyPublisher<DataResponse<ThreeHourlyResponse, NetworkError>, Never>{
        let params: [String: Any] = [
            "lat": location.lat,
            "lon": location.lon,
            "units": "metric", // standard, metric(섭씨), imperial(화씨)
            "lang": "en"
        ]as Parameters
        return self.getData("data/2.5/forecast", paramters: params)
    }
}
