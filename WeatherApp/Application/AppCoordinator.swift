//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/10.
//

import Foundation
import UIKit
import Network
import PinLayout
import FlexLayout

enum AlertType {
    case ok(onClickOk: ()->())
    case yesOrNo(onClickYes: ()->(), onClickNo: ()->())
}

final class AppCoordinator {
    private let navigationController: UINavigationController
    private let monitor = NWPathMonitor()
    let appDIContainer = AppDIContainer.shared
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                // 이 곳은 메인 스레드가 아니기 때문에
                // UI 변화를 하기 위해서는 DispatchQueue.main.async 를 호출해야 한다.
                DispatchQueue.main.async {
                    
                }
            } else {
                // 위와 같은 이유로 DispatchQueue.main.async 사용
                DispatchQueue.main.async {
                    self.presentAlertView(.ok(onClickOk: {
                        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            exit(0)
                        }
                    }), title: "network_disconnection_title".localized(), message: "network_disconnection_description".localized())
                }
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func pop(_ animated: Bool = true) {
        self.navigationController.popViewController(animated: animated)
    }
    
    func start() {
        let vc = SplashViewController(vm: DefaultSplashViewModel(
            self,
            locationRespository: appDIContainer.locationRespository,
            weatherService: appDIContainer.weatherService,
            locationService: appDIContainer.locationService,
            geocodingService: appDIContainer.geocodingService
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
            locationService: appDIContainer.locationService,
            geocodingService: appDIContainer.geocodingService
        ))
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func presentSelectUnitView(_ onDismiss: @escaping ()->()) {
        let lastVC = self.navigationController.viewControllers.last
        let vc = SelectUnitViewController(vm: DefaultSelectUnitViewModel(self, onDismiss: onDismiss))
        
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.view.backgroundColor = .black.withAlphaComponent(0.4)
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
