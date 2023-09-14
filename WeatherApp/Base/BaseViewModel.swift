//
//  BaseViewModel.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/11.
//

import Foundation
import Combine
import Network
import UIKit
/*
 https://velog.io/@aurora_97/Combine-UIKit-MVVM-Combine-%EC%98%88%EC%A0%9C
 
 https://api.openweathermap.org/data/3.0/onecall?lat={lat}&lon={lon}&exclude={part}&appid={API key}
*/

class BaseViewModel {
    var subscription: Set<AnyCancellable> = []
    let coordinator: AppCoordinator
    
    
    init(_ coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    deinit {
        subscription.forEach {
            $0.cancel()
        }
    }
    
}
