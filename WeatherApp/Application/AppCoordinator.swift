//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/10.
//

import Foundation
import UIKit

final class AppCoordinator {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.navigationController.pushViewController(MainViewController(vm: MainViewModel()), animated: false)
    }
    
}
