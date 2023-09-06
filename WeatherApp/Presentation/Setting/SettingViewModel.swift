//
//  SettingViewModel.swift
//  WeatherApp
//
//  Created by sandy on 2023/09/06.
//

import Foundation
import Alamofire
import Combine


protocol SettingViewModel: SettingViewModelInput, SettingViewModelOutput { }

protocol SettingViewModelInput {
    func viewWillAppear()
    func viewDidLoad()
}

protocol SettingViewModelOutput {
    var isLoading: Observable<Bool> { get }
}

class DefaultSettingViewModel: BaseViewModel {
    var isLoading: Observable<Bool> = Observable(false)
    
    override init(_ coordinator: AppCoordinator) {
        super.init(coordinator)
    }
}

extension DefaultSettingViewModel: SettingViewModel {
    func viewDidLoad() { }
    
    func viewWillAppear() {
        self.isLoading.value = false
    }
}
