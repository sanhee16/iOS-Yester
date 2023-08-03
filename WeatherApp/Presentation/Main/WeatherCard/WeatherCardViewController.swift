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
    
    let location: Location?
    
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
    
    
    private let cardView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.backgroundColor = .white.withAlphaComponent(0.14)
        stackView.layer.cornerRadius = 16
        return stackView
    }()
    
    init(vm: VM, location: Location?) {
        self.location = location
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.cardView)

        self.cardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
        }
        
        if let location = self.location {
            [info].forEach {
                self.cardView.addArrangedSubview($0)
            }
            self.info.text = "lat: \(String(format: "%0.3f", location.lat)) // lon: \(String(format: "%0.3f", location.lon)) // isStar: \(location.isStar)"
            
            self.info.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            [addButton].forEach {
                self.cardView.addArrangedSubview($0)
            }
            self.addButton.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
            
            self.addButton.addTarget(self, action: #selector(self.onClickAddLocation), for: .touchUpInside)
        }
    }
    
    @objc func onClickAddLocation() {
        vm.onClickAddLocation()
    }
    
    @objc func onClickDelete() {
        guard let location = self.location else { return }
        vm.onClickDelete(item: location)
    }
    
    @objc func onClickStar() {
        guard let location = self.location else { return }
        vm.onClickStar(item: location)
    }
}
