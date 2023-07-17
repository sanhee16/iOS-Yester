//
//  WeatherDIContainer.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/17.
//

import Foundation
import UIKit


final class WeatherDIContainer {
    let locationRespository: AnyRepository<Location>
    
    init() {
        self.locationRespository = AnyRepository()
    }
    
    func makeCoordinator(navigationController: UINavigationController) {
        navigationController.pushViewController(
            MainViewController(vm: DefaultMainViewModel(locationRespository: self.locationRespository)),
            animated: false
        )
    }
    
}
