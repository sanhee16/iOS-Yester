//
//  SplashViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/08/04.
//

import Foundation
import UIKit
import SwiftUI
import Combine

class SplashViewController: BaseViewController {
    typealias VM = SplashViewModel
    
    private let vm: VM
    
    private let searchButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var lottieVC: LottieVC = {
        let lottieVC = LottieVC(type: .splash)
        return lottieVC
    }()
    
    init(vm: VM) {
        self.vm = vm
        super.init()
        self.bind(to: vm)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(to vm: VM) {
        
    }
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        vm.viewDidLoad()
        self.addSubViews()
        
        self.lottieVC.view.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.viewWillAppear()
    }
    
    private func addSubViews() {
        self.addChild(self.lottieVC)
        
        [self.lottieVC.view].forEach {
            self.view.addSubview($0)
        }
    }
}
