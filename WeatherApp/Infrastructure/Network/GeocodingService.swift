//
//  GeocodingService.swift
//  WeatherApp
//
//  Created by sandy on 2023/09/12.
//


import Foundation
import Alamofire
import Combine
import CoreLocation

protocol GeocodingServiceProtocol {
    var geocodingUrl: String { get }
    var reverseGeocodingUrl: String { get }
    var apiKey: String { get }
}

class GeocodingService: GeocodingServiceProtocol {
    var geocodingUrl: String
    var reverseGeocodingUrl: String
    var apiKey: String
    
    init(geocodingUrl: String, reverseGeocodingUrl: String, apiKey: String) {
        self.geocodingUrl = geocodingUrl
        self.reverseGeocodingUrl = reverseGeocodingUrl
        self.apiKey = apiKey
    }
    
    private func getData<T: Decodable>(_ url: String, headers: HTTPHeaders? = nil, paramters: Parameters? = nil) -> AnyPublisher<DataResponse<T, NetworkError>, CommonError> {
        let url = URL(string: url)!
        var params = paramters
        params?["appid"] = self.apiKey
        return AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers)
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
            .setFailureType(to: CommonError.self)
            .eraseToAnyPublisher()
    }
    
    
    
    
    
    
//
//    func getGeocoding(_ name: String) -> AnyPublisher<DataResponse<[ReverseGeocoding], NetworkError>, CommonError> {
//        return self.geocoding(name)
//            .flatMap({[weak self] (response) -> AnyPublisher<DataResponse<[ReverseGeocoding], NetworkError>, CommonError> in
//                guard let self = self, let geocoding = response.value else { return Fail(error: CommonError(type: .unknown, message: nil)).eraseToAnyPublisher() }
//                reverseGeocoding(geocoding).eraseToAnyPublisher()
//            }).eraseToAnyPublisher()
//    }
    func getGeocoding(_ name: String) -> AnyPublisher<DataResponse<[GeocodingResponse], NetworkError>, CommonError> {
        let params: [String: Any] = [
            "q": name,
            "limit": 10
        ] as Parameters
        return self.getData("\(self.geocodingUrl)geo/1.0/direct", paramters: params)
    }
    
    
    func getReverseGeocoding(_ geocoding: GeocodingResponse) -> AnyPublisher<DataResponse<ReverseGeocoding, NetworkError>, CommonError> {
        let params: [String: Any] = [
            "format": "json",
            "lat": geocoding.lat,
            "lon": geocoding.lon
        ] as Parameters
        
        let header: HTTPHeaders = HTTPHeaders([HTTPHeader(name: "Accept-Language", value: Utils.languageCode())])
        
        return self.getData("\(self.reverseGeocodingUrl)reverse", headers: header, paramters: params)
    }
    
    func getReverseGeocoding(_ coordinate: CLLocationCoordinate2D) -> AnyPublisher<DataResponse<ReverseGeocoding, NetworkError>, CommonError> {
        let params: [String: Any] = [
            "format": "json",
            "lat": coordinate.latitude,
            "lon": coordinate.longitude
        ] as Parameters
        
        let header: HTTPHeaders = HTTPHeaders([HTTPHeader(name: "Accept-Language", value: Utils.languageCode())])
        return self.getData("\(self.reverseGeocodingUrl)reverse", headers: header, paramters: params)
    }
}

