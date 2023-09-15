//
//  SettingViewModel.swift
//  WeatherApp
//
//  Created by sandy on 2023/09/06.
//

import Foundation
import Alamofire
import Combine
import UIKit

protocol SettingViewModel: SettingViewModelInput, SettingViewModelOutput { }

protocol SettingViewModelInput {
    func viewWillAppear()
    func viewDidLoad()
    
    func onClickUnit()
    func onClickIcon8()
}

protocol SettingViewModelOutput {
    var isLoading: Observable<Bool> { get }
    var unitText: Observable<String> { get }
}

class DefaultSettingViewModel: BaseViewModel {
    var isLoading: Observable<Bool> = Observable(false)
    var unitText: Observable<String> = Observable(C.weatherUnit.unitText)
    
    override init(_ coordinator: AppCoordinator) {
        super.init(coordinator)
    }
}

extension DefaultSettingViewModel: SettingViewModel {
    func viewDidLoad() { }
    
    func viewWillAppear() {
        self.isLoading.value = false
    }
    
    func onClickUnit() {
        self.coordinator.presentSelectUnitView { [weak self] in
            guard let self = self else { return }
            self.unitText.value = C.weatherUnit.unitText
        }
    }
    
    func onClickIcon8() {
        print("onclickicons8")
        if let url = URL(string: "https://icons8.kr") {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
