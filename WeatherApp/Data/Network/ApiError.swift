//
//  ApiError.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/22.
//

import Foundation
import Alamofire

// 1. Error 타입 정의
struct NetworkError: Error {
    let initialError: AFError
    let weatherError: WeatherError?
}

struct WeatherError: Codable, Error {
    var code: Int
    var message: String
    var parameters: [String]
}
