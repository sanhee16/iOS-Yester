//
//  NavigationController.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/29.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.navigationBar.tintColor = .black

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
