//
//  WeatherCardViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/17.
//

import Foundation
import UIKit
import SnapKit
import SwiftUI
import PinLayout
import FlexLayout

class WeatherCardViewController: UIViewController {
    typealias VM = MainViewModel
    private let vm: VM
    
    var item: WeatherCardItem?
    var isAddCard: Bool {
        item == nil
    }
    
    let addButton: UIButton = UIButton()
    
    private lazy var rootFlexContainer: UIView = UIView()
    // Header
    private lazy var currentTempLabel: UILabel = UILabel()
    private lazy var currentDescriptionLabel: UILabel = UILabel()
    private lazy var currentWeatherImage: UIImageView = UIImageView()
    private lazy var locationLabel: UILabel = UILabel()
    private lazy var tempDescription: UILabel = UILabel()
    
    init(vm: VM, item: WeatherCardItem?) {
        self.vm = vm
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
    }
    
    private func setLayout() {
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.backgroundColor(.white.withAlphaComponent(0.13))
        rootFlexContainer.flex.cornerRadius(16)
        
        if let item = self.item, let currentWeather = item.currentWeather {
            let daily = item.dailyWeather
            let hourly = item.threeHourly
            
            rootFlexContainer.flex
                .padding(16)
                .define { flex in
                    // HEADER
                    flex.addItem()
                        .direction(.row)
                        .justifyContent(.spaceBetween)
                        .padding(0)
                        .define { flex in
                            flex.addItem()
                                .direction(.column)
                                .define { flex in
                                    currentTempLabel.font = .en38
                                    currentTempLabel.text = String(format: "%.1f", currentWeather.temp)
                                    
                                    currentDescriptionLabel.font = .en20
                                    currentDescriptionLabel.text = currentWeather.weather.first?.description
                                    
                                    currentWeatherImage.contentMode = .scaleAspectFit
                                    currentWeatherImage.image = UIImage(named: currentWeather.weather.first?.icon ?? "")?.resized(toWidth: 80.0)
                                    
                                    locationLabel.font = .en16
                                    locationLabel.text = item.location.name
                                    
                                    flex.addItem(currentTempLabel)
                                    flex.addItem(currentDescriptionLabel)
                                    flex.addItem()
                                        .direction(.row)
                                        .marginTop(20)
                                        .define { flex in
                                            flex.addItem(locationLabel)
                                            if item.location.isCurrent {
                                                let locationImage: UIImageView = UIImageView()
                                                locationImage.contentMode = .scaleAspectFit
                                                locationImage.image = UIImage(systemName: "location.fill")?.resized(toWidth: 15)
                                                flex.addItem(locationImage).marginLeft(4)
                                            }
                                        }
                                    
                                    tempDescription.font = .en16
                                    tempDescription.text = String(format: "%.1f / %.1f  체감 온도 %.1f", daily.first?.temp.min ?? 0.0, daily.first?.temp.max ?? 0.0, currentWeather.feels_like)
                                    flex.addItem(tempDescription).marginTop(2)
                                }
                            flex.addItem(currentWeatherImage).alignSelf(.start)
                        }
                }
        } else {
            rootFlexContainer.flex
                .justifyContent(.center)
                .define { flex in
                    let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
                    let addImageBold = UIImage(systemName: "plus", withConfiguration: config)?.withTintColor(.black, renderingMode: .alwaysOriginal)
                    addButton.setImage(addImageBold, for: .normal)
                    addButton.addTarget(self, action: #selector(self.onClickAddLocation), for: .touchUpInside)
                    
                    flex.addItem(addButton)
                }
        }
    }
            
    @objc func onClickAddLocation() {
        vm.onClickAddLocation()
    }
}
