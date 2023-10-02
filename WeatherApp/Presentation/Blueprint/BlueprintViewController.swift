//
//  BlueprintViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/08/04.
//

import Foundation
import UIKit
import SwiftUI
import Combine

class BlueprintViewController: BaseViewController {
    typealias VM = BlueprintViewModel
    
    private let vm: VM
    
    private let searchButton: UIButton = {
        let button = UIButton()
        
        return button
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
        vm.sample.observe(on: self) {[weak self] str in
            
        }
    }
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        vm.viewDidLoad()
        self.addSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.viewWillAppear()
    }
    
    private func addSubViews() {
        [searchButton].forEach {
            self.view.addSubview($0)
        }
    }
}
