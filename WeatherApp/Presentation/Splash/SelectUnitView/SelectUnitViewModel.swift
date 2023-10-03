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
    
    func onClickUnit(unit: WeatherUnit)
    var unit: Observable<WeatherUnit> { get }
}

protocol SelectUnitViewModelOutput {
    
}

class DefaultSelectUnitViewModel: BaseViewModel, SelectUnitViewModel {
    var unit: Observable<WeatherUnit> = Observable(WeatherUnit(rawValue: Defaults.weatherUnit) ?? .metric)
    var onDismiss: ()->()
    
    init(_ coordinator: AppCoordinator, onDismiss: @escaping ()->()) {
        self.onDismiss = onDismiss
        super.init(coordinator)
    }
    
    func viewWillAppear() {
        
    }
    
    func viewDidLoad() {
        self.bind()
    }
    
    func bind() {
    }
    
    func onClickUnit(unit: WeatherUnit) {
        self.unit.value = unit
    }
    
    
    func onClickSave() {
        changeUnit()
        self.coordinator.dismissSelectUnitView(onDismiss)
    }
    
    func changeUnit() {
        Defaults.weatherUnit = self.unit.value.rawValue
        C.weatherUnit = self.unit.value
    }
}

