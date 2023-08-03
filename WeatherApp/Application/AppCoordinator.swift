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
    let appDIContainer = AppDIContainer.shared
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func pop(_ animated: Bool = true) {
        self.navigationController.popViewController(animated: animated)
    }
    
    func start() {
        self.navigationController.pushViewController(
            MainViewController(vm: DefaultMainViewModel(
                self,
                locationRespository: appDIContainer.locationRespository,
                weatherService: appDIContainer.weatherService)
            ),
            animated: false
        )
    }
    
    func presentSelectLocation() {
        let vc = SelectLocationViewController(vm: DefaultSelectLocationViewModel(
            self,
            locationRespository: appDIContainer.locationRespository,
            weatherService: appDIContainer.weatherService,
            locationService: appDIContainer.locationService)
        )
        self.navigationController.pushViewController(vc, animated: true)
    }
}
