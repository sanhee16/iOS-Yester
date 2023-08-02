//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/10.
//

import Foundation
import UIKit

final class AppCoordinator {
    private let navigationController: UINavigationController
    let weatherDIContainer = WeatherDIContainer.shared
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.navigationController.pushViewController(
            MainViewController(vm: DefaultMainViewModel(self, locationRespository: weatherDIContainer.locationRespository)),
            animated: false
        )
    }
    
    func presentSelectLocation() {
        let vc = SelectLocationViewController(vm: DefaultSelectLocationViewModel(self, locationRespository: weatherDIContainer.locationRespository, weatherService: weatherDIContainer.weatherService))
        self.navigationController.pushViewController(vc, animated: true)
    }
}
