//
//  SelectLocationViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/18.
//


import UIKit
import SwiftUI
import Combine
import SnapKit

class SelectLocationViewController: BaseViewController {
    typealias VM = SelectLocationViewModel
    
    private let vm: VM
    
    private let searchField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "지역 검색하기"
        textField.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        textField.clearButtonMode = .whileEditing
        
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        textField.leftViewMode = .always

        return textField
    }()
    private let listArea: UILabel = UILabel()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("찾기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
        button.layer.cornerRadius = 10
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)

        return button
    }()
    
    private let searchView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 8
        return stackView
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
        
        searchView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        searchField.setContentCompressionResistancePriority(.init(1), for: .horizontal)
        searchButton.setContentCompressionResistancePriority(.init(2), for: .horizontal)
        
        searchField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        searchButton.addTarget(self, action: #selector(self.onClickSearchLocation), for: .touchUpInside)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.viewWillAppear()
    }
    
    private func addSubViews() {
        [listArea, searchView].forEach {
            self.view.addSubview($0)
        }
        [searchField, searchButton].forEach {
            self.searchView.addArrangedSubview($0)
        }
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
