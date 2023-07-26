//
//  SelectLocationViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/18.
//


import UIKit
import SwiftUI
import Combine

class SelectLocationViewController: BaseViewController {
    typealias VM = SelectLocationViewModel
    
    private let vm: VM
    private let searchField: UITextField = UITextField()
    private let search: UIButton = UIButton()
    private let listArea: UILabel = UILabel()
    
    init(vm: VM) {
        self.vm = vm
        super.init()
        self.bind(to: vm)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(to vm: VM) {
        vm.results.observe(on: self) { [weak self] list in
            guard let self = self else { return }
            self.listArea.text?.removeAll()
            list.forEach { item in
                self.listArea.text?.append("\(item.localNames): \(item.lat)-\(item.lon)")
            }
        }
    }
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        self.addSubViews()
        
        searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        searchField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        searchField.placeholder = "지역 검색하기"
        searchField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        
        
        search.setTitle("찾기", for: .normal)
        search.setTitleColor(.systemPink, for: .normal)
        
        search.topAnchor.constraint(equalTo: searchField.topAnchor, constant: 0).isActive = true
        search.bottomAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 0).isActive = true
        search.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        search.addTarget(self, action: #selector(self.onClickSearchLocation), for: .touchUpInside)

        
        listArea.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 40).isActive = true
        listArea.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        listArea.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        listArea.backgroundColor = .yellow
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vm.viewWillAppear()
    }
    
    private func addSubViews() {
        self.view.addSubview(self.searchField)
        self.view.addSubview(self.search)
        self.view.addSubview(self.listArea)
        
        searchField.translatesAutoresizingMaskIntoConstraints = false
        search.translatesAutoresizingMaskIntoConstraints = false
        listArea.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func onClickSearchLocation() {
        print("onClickSearchLocation")
        vm.onClickSearch()
    }

    @objc private func textFieldDidChange(sender: UITextField) {
        switch sender {
        case searchField:
            vm.name.value = sender.text!
            print("value: \(vm.name.value)")
        default: break
        }
    }
}
