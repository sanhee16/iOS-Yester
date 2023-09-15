//
//  SplashViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/08/04.
//

import Foundation
import PinLayout
import FlexLayout
import SwiftUI
import Combine


class SplashViewController: BaseViewController {
    typealias VM = SplashViewModel
    
    private let vm: VM
    
    fileprivate lazy var rootFlexContainer: UIView = UIView()
    
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
        
        
        
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.viewWillAppear()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexContainer.pin.all(view.pin.safeArea)
        
        self.layout()
    }
    
    private func layout() {
        rootFlexContainer.flex.layout()
    }
    
    private func setLayout() {
        self.view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex
            .direction(.column)
            .justifyContent(.center)
            .define { flex in
                let imageView: UIImageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                imageView.image = UIImage(named: "splashIcon")?.resized(toWidth: 100)
                
                flex.addItem(imageView)
            }
    }
    
}
