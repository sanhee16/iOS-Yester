//
//  BaseViewModel.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/11.
//

import Foundation
import Combine
/*
 https://api.openweathermap.org/data/3.0/onecall?lat={lat}&lon={lon}&exclude={part}&appid={API key}
*/
class BaseViewModel {
    struct Input { }
    struct Output { }
    private var cancellables = Set<AnyCancellable>()

    
}
