//
//  WeatherCardViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/17.
//

import Foundation
import UIKit
import SnapKit

class WeatherCardViewController: UIViewController {
    typealias VM = MainViewModel
    private let vm: VM
    
    var item: WeatherCardItem?
    
    let addButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
        let addImageBold = UIImage(systemName: "plus", withConfiguration: config)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        button.setImage(addImageBold, for: .normal)
        return button
    }()
    
    let info: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    let cardHeader: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.backgroundColor = .white.withAlphaComponent(0.5)
        stackView.layer.cornerRadius = 6
        stackView.isLayoutMarginsRelativeArrangement = true

        stackView.layoutMargins = UIEdgeInsets(top: 6.0, left: 12.0, bottom: 6.0, right: 12.0)

        return stackView
    }()
     
    // Header
    private lazy var currentTempLabel: UILabel = {
        let label = UILabel()
        label.text = "currentTempLabel"
        return label
    }()
    
    private lazy var locationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "locationNameLabel"
        return label
    }()
    
    private let cardView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.backgroundColor = .white.withAlphaComponent(0.14)
        stackView.layer.cornerRadius = 16
        return stackView
    }()
    
    init(vm: VM, item: WeatherCardItem?) {
        self.vm = vm
        self.item = item
        print("[WeatherCardVC] init: \(item?.location)")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubViews()
        
        self.cardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
        }
        
        if let item = self.item {
            addHeader(item)
        } else {
            addAddButton()
        }
    }
    
    private func addSubViews() {
        [cardView, cardHeader].forEach {
            self.view.addSubview($0)
        }
        
        [currentTempLabel, locationNameLabel].forEach {
            self.cardHeader.addArrangedSubview($0)
        }
    }
    
    private func addHeader(_ item: WeatherCardItem) {
        self.cardHeader.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        if let currentWeather = item.currentWeather {
            self.currentTempLabel.text = String(format: "%.2f", currentWeather.temp)
        } else {
            self.currentTempLabel.text = ""
        }
        
        self.currentTempLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        self.locationNameLabel.text = "\(item.location.name)"
        self.locationNameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.currentTempLabel.snp.bottom)
        }
    }
    
    private func addAddButton() {
        [addButton].forEach {
            self.cardView.addArrangedSubview($0)
        }
        self.addButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        self.addButton.addTarget(self, action: #selector(self.onClickAddLocation), for: .touchUpInside)
    }
    
    @objc func onClickAddLocation() {
        vm.onClickAddLocation()
    }
    
//    @objc func onClickDelete() {
//        guard let item = self.item else { return }
//        vm.onClickDelete(location: item.location)
//    }
//
//    @objc func onClickStar() {
//        guard let item = self.item else { return }
//        vm.onClickStar(location: item.location)
//    }
}
