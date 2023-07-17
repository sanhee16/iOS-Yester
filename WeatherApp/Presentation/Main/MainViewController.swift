//
//  MainViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/10.
//

import UIKit
import SwiftUI
import Combine



class MainViewController: BaseViewController {
    typealias VM = MainViewModel
    
    private let vm: VM
    private var locations: [Location]
    
    private let btnAdd: UIButton = UIButton()
    private let locationList: UILabel = UILabel()
    
    init(vm: VM) {
        self.vm = vm
        self.locations = []
        super.init()
        self.bind(to: vm)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(to vm: VM) {
        vm.locations.observe(on: self) { [weak self] locations in
            guard let self = self else { return }
            self.locations = locations
            self.locationList.text = ""
            print("observe: \(locations)")
            self.locations.forEach { location in
                self.locationList.text! += "lat: \(String(format: "%0.3f", location.lat)) // lon: \(String(format: "%0.3f", location.lon)) // isStar: \(location.isStar)\n"
            }
        }
    }
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        self.addSubViews()
        
        self.btnAdd.setTitle("추가하기", for: .normal)
        self.btnAdd.setTitleColor(.black, for: .normal)
        self.btnAdd.backgroundColor = .green
        
        
        btnAdd.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        btnAdd.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        btnAdd.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        btnAdd.isEnabled = true
        self.btnAdd.addTarget(self, action: #selector(self.onClickAddLocation), for: .touchUpInside)
        
        self.locationList.text = ""
        locationList.backgroundColor = .orange
        self.locationList.textColor = .black
        locationList.topAnchor.constraint(equalTo: btnAdd.bottomAnchor).isActive = true
        locationList.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        locationList.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        locationList.numberOfLines = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vm.viewWillAppear()
    }
    
    private func addSubViews() {
        self.view.addSubview(self.btnAdd)
        self.view.addSubview(self.locationList)
        
        btnAdd.translatesAutoresizingMaskIntoConstraints = false
        locationList.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func onClickAddLocation() {
        print("onClickAddLocation")
        vm.onClickAdd()
    }
}
