//
//  SelectUnitViewModel.swift
//  WeatherApp
//
//  Created by sandy on 2023/08/22.
//

import Foundation
import Combine
import Alamofire
import CoreLocation

protocol SelectUnitViewModel: SelectUnitViewModelInput, SelectUnitViewModelOutput { }

protocol SelectUnitViewModelInput {
    func viewWillAppear()
    func viewDidLoad()
    func onClickSave()
    
    func onClickUnit(key: String, value: Int)
    var units: Observable<[String: Int]> { get }
}

protocol SelectUnitViewModelOutput {
    
}

class DefaultSelectUnitViewModel: BaseViewModel, SelectUnitViewModel {
    var units: Observable<[String: Int]> = Observable([:])
    var onDismiss: ()->()
    
    init(_ coordinator: AppCoordinator, onDismiss: @escaping ()->()) {
        self.onDismiss = onDismiss
        super.init(coordinator)
        Defaults.units.forEach { (key, value) in
            units.value[key] = value
        }
    }
    
    func viewWillAppear() {
        
    }
    
    func viewDidLoad() {
        self.bind()
    }
    
    func bind() {
    }
    
    func onClickUnit(key: String, value: Int) {
        units.value[key] = value
    }
    
    func setUnits() {
        Defaults.units.forEach { (key, value) in
            C.units[key] = value
        }
    }
    
    func onClickSave() {
        Defaults.units = self.units.value
        self.coordinator.dismissSelectUnitView(onDismiss)
    }
    
}

