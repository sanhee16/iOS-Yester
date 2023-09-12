//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/10.
//

import Foundation
import UIKit


enum AlertType {
    case ok(onClickOk: ()->())
    case yesOrNo(onClickYes: ()->(), onClickNo: ()->())
}

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
        let vc = SplashViewController(vm: DefaultSplashViewModel(
            self,
            locationRespository: appDIContainer.locationRespository,
            weatherService: appDIContainer.weatherService,
            locationService: appDIContainer.locationService
        ))
        
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func presentMainView() {
        let vc = MainViewController(vm: DefaultMainViewModel(
            self,
            locationRespository: appDIContainer.locationRespository,
            weatherService: appDIContainer.weatherService,
            weatherServiceV2: appDIContainer.weatherServiceV2,
            locationService: appDIContainer.locationService
        ))
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func presentManageLocation() {
        let vc = ManageLocationViewController(vm: DefaultManageLocationViewModel(
            self,
            locationRespository: appDIContainer.locationRespository,
            locationService: appDIContainer.locationService
        ))
        
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    
    func presentSetting() {
        let vc = SettingViewController(vm: DefaultSettingViewModel(
            self
        ))
        
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    
    func presentSelectLocation() {
        let vc = SelectLocationViewController(vm: DefaultSelectLocationViewModel(
            self,
            locationRespository: appDIContainer.locationRespository,
            weatherService: appDIContainer.weatherService,
            weatherServiceV2: appDIContainer.weatherServiceV2,
            locationService: appDIContainer.locationService)
        )
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func presentSelectUnitView(_ onDismiss: @escaping ()->()) {
        let lastVC = self.navigationController.viewControllers.last
        let vc = SelectUnitViewController(vm: DefaultSelectUnitViewModel(self, onDismiss: onDismiss))
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.view.backgroundColor = .clear
        
        lastVC?.present(vc, animated: true)
    }
    
    func dismissSelectUnitView(_ onDismiss: @escaping ()->()) {
        let lastVC = self.navigationController.viewControllers.last
        lastVC?.dismiss(animated: true)
        onDismiss()
    }
    
    
    func presentAlertView(_ type: AlertType, title: String? = "", message: String? = "") {
        let lastVC = self.navigationController.viewControllers.last
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        switch type {
        case let .ok(onClickOk):
            alertVC.addAction(UIAlertAction(title: "ok".localized(), style: .destructive, handler: { _ in onClickOk() }))
            break
        case let .yesOrNo(onClickYes, onClickNo):
            alertVC.addAction(UIAlertAction(title: "ok".localized(), style: .destructive, handler: { _ in onClickYes() }))
            alertVC.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel, handler: { _ in onClickNo() }))
            break
        }
        lastVC?.present(alertVC, animated: true)
    }
}
