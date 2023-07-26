//
//  Api.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/22.
//

import Foundation
import Alamofire
import Combine

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
            "q": name
        ] as Parameters
        return self.getData("geo/1.0/direct", paramters: params)
    }
    
}
