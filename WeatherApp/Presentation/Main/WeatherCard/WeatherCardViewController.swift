//
//  WeatherCardViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/09/13.
//

import Foundation
import UIKit
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
    
    
    fileprivate lazy var rootFlexContainer: UIView = UIView()
    
    // Card
    fileprivate lazy var cardScrollView: UIScrollView = UIScrollView()
    fileprivate lazy var cardContentView: UIView = UIView()
    
    // Hourly
    fileprivate lazy var hourlyScrollView: UIScrollView = UIScrollView()
    fileprivate lazy var hourlyContentView: UIView = UIView()
    fileprivate lazy var hourlyView: UIView = UIView()
    
    
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
        
        //[TROUBLE_SHOOTING]: hourly scrollview indicator 영역 잡히는 이슈 수정
        hourlyScrollView.showsVerticalScrollIndicator = false
        hourlyScrollView.showsHorizontalScrollIndicator = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
        
        // cardScrollView
        cardScrollView.pin.all()
        
        cardContentView.flex.layout(mode: .adjustHeight)
        cardScrollView.contentSize = cardContentView.frame.size
        
        cardScrollView.showsVerticalScrollIndicator = false
        cardScrollView.showsHorizontalScrollIndicator = false
        
        // hourlyScrollView
        hourlyContentView.pin.all() // The view fill completely its parent
        hourlyContentView.flex.layout(mode: .adjustWidth)
        hourlyScrollView.contentSize = hourlyContentView.frame.size
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setLayout() {
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.backgroundColor(.white.withAlphaComponent(0.13))
        rootFlexContainer.flex.cornerRadius(20)
        
        if let item = self.item, let _ = item.currentWeather {
            rootFlexContainer.flex
                .marginHorizontal(14)
                .direction(.column)
                .define { flex in
                    hourlyView.addSubview(hourlyScrollView)
                    
                    // CARD
                    flex.addItem(cardScrollView)
                        .define { flex in
                            flex.addItem(cardContentView)
                                .padding(UIEdgeInsets(top: 20, left: 16, bottom: 40, right: 16))
                                .direction(.column)
                                .define { flex in
                                    // HEADER
                                    drawHeader(flex)
                                    // 3Hour
                                    drawHourly(flex)
                                    // Weekly
                                    drawWeekly(flex)
                                    // Extra
                                    drawExtra(flex)
                                }
                            
                        }
                }
        } else {
            rootFlexContainer.flex
                .margin(0, 16)
                .justifyContent(.center)
                .define { flex in
                    let addButton: UIButton = UIButton()
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
    
    private func drawExtra(_ flex: Flex) {
        guard let current = self.item?.currentWeather, let today = self.item?.daily.first else { return }
        flex.addItem()
            .direction(.column)
            .marginTop(16)
            .define { flex in
                flex.addItem()
                    .direction(.row)
                    .justifyContent(.spaceBetween)
                    .define { flex in
                        flex.addItem()
                            .height(100)
                            .width(100%)
                            .shrink(1)
                            .backgroundColor(.white.withAlphaComponent(0.13))
                            .cornerRadius(12)
                            .alignItems(.center)
                            .justifyContent(.center)
                            .direction(.column)
                            .define { flex in
                                let image: UIImageView = UIImageView()
                                image.contentMode = .scaleAspectFit
                                image.image = UIImage(named: "wind_speed")?.resized(toWidth: 34.0)
                                
                                let name: UILabel = UILabel()
                                name.font = .en16b
                                name.text = String(format: "%@", "wind_speed".localized())
                                
                                let value: UILabel = UILabel()
                                value.font = .en14r
                                value.text = String(format: "%.0f %@", current.windSpeed, C.weatherUnit.windUnit)
                                
                                flex.addItem(image)
                                flex.addItem(name)
                                flex.addItem(value)
                            }
                        
                        flex.addItem()
                            .height(100)
                            .width(14)
                        
                        flex.addItem()
                            .height(100)
                            .width(100%)
                            .shrink(1)
                            .backgroundColor(.white.withAlphaComponent(0.13))
                            .cornerRadius(12)
                            .alignItems(.center)
                            .justifyContent(.center)
                            .direction(.column)
                            .define { flex in
                                let image: UIImageView = UIImageView()
                                image.contentMode = .scaleAspectFit
                                image.image = UIImage(named: "uvi")?.resized(toWidth: 34.0)
                                
                                let name: UILabel = UILabel()
                                name.font = .en16b
                                name.text = String(format: "%@", "uvi".localized())
                                
                                let value: UILabel = UILabel()
                                value.font = .en14r
                                value.text = String(format: "%@ (%d)", current.uvi.uviText(), current.uvi)
                                
                                flex.addItem(image)
                                flex.addItem(name)
                                flex.addItem(value)
                            }
                    }
                flex.addItem()
                    .direction(.row)
                    .marginTop(14)
                    .define { flex in
                        flex.addItem()
                            .height(100)
                            .width(100%)
                            .shrink(1)
                            .backgroundColor(.white.withAlphaComponent(0.13))
                            .cornerRadius(12)
                            .alignItems(.center)
                            .justifyContent(.center)
                            .direction(.column)
                            .define { flex in
                                let image: UIImageView = UIImageView()
                                image.contentMode = .scaleAspectFit
                                image.image = UIImage(named: "humidity")?.resized(toWidth: 34.0)
                                
                                let name: UILabel = UILabel()
                                name.font = .en16b
                                name.text = String(format: "%@", "humidity".localized())
                                
                                let value: UILabel = UILabel()
                                value.font = .en14r
                                value.text = String(format: "%d %%", current.humidity)
                                
                                flex.addItem(image)
                                flex.addItem(name)
                                flex.addItem(value)
                            }
                        
                        flex.addItem()
                            .height(100)
                            .width(14)
                        
                        flex.addItem()
                            .height(100)
                            .width(100%)
                            .shrink(1)
                            .justifyContent(.spaceEvenly)
                            .backgroundColor(.white.withAlphaComponent(0.13))
                            .cornerRadius(12)
                            .direction(.row)
                            .define { flex in
                                flex.addItem()
                                    .alignItems(.center)
                                    .justifyContent(.center)
                                    .direction(.column)
                                    .define { flex in
                                        let image: UIImageView = UIImageView()
                                        image.contentMode = .scaleAspectFit
                                        image.image = UIImage(named: "sunrise")?.resized(toWidth: 34.0)
                                        
                                        let name: UILabel = UILabel()
                                        name.font = .en16b
                                        name.text = String(format: "%@", "sunrise".localized())
                                        
                                        let value: UILabel = UILabel()
                                        value.font = .en14r
                                        value.text = Utils.intervalSunTime(today.sunrise)
                                        
                                        
                                        flex.addItem(image)
                                        flex.addItem(name)
                                        flex.addItem(value)
                                    }
                                flex.addItem()
                                    .alignItems(.center)
                                    .justifyContent(.center)
                                    .direction(.column)
                                    .define { flex in
                                        let image: UIImageView = UIImageView()
                                        image.contentMode = .scaleAspectFit
                                        image.image = UIImage(named: "sunset")?.resized(toWidth: 34.0)
                                        
                                        let name: UILabel = UILabel()
                                        name.font = .en16b
                                        name.text = String(format: "%@", "sunset".localized())
                                        
                                        let value: UILabel = UILabel()
                                        value.font = .en14r
                                        value.text = Utils.intervalSunTime(today.sunset)
                                        
                                        flex.addItem(image)
                                        flex.addItem(name)
                                        flex.addItem(value)
                                    }
                            }
                    }
            }
    }
    
    private func drawWeekly(_ flex: Flex) {
        guard let weekly = self.item?.daily else { return }
        flex.addItem()
            .direction(.column)
            .backgroundColor(.white.withAlphaComponent(0.13))
            .cornerRadius(12)
            .marginTop(16)
            .padding(6, 14, 10, 14)
            .define { flex in
                if let yesterday = self.item?.yesterday {
                    flex.addItem()
                        .direction(.row)
                        .justifyContent(.spaceBetween)
                        .paddingTop(4)
                        .define { flex in
                            drawWeeklyItem(
                                flex,
                                weekdayText: "yesterday".localized(),
                                minTemp: C.weatherUnit == .metric ? yesterday.day.mintemp_c : yesterday.day.mintemp_f,
                                maxTemp: C.weatherUnit == .metric ? yesterday.day.maxtemp_c : yesterday.day.maxtemp_f,
                                rainChance: nil,
                                iconImage: yesterday.day.iconImage()?.resized(toWidth: 30.0)
                            )
                        }
                }
                weekly.indices.forEach { idx in
                    let daily = weekly[idx]
                    flex.addItem()
                        .direction(.row)
                        .justifyContent(.spaceBetween)
                        .paddingTop(4)
                        .define { flex in
                            drawWeeklyItem(
                                flex,
                                weekdayText: idx == 0 ? "today".localized() : Utils.intervalToWeekday(daily.dt),
                                minTemp: daily.temp.min,
                                maxTemp: daily.temp.max,
                                rainChance: daily.pop,
                                iconImage: daily.iconImage(30.0)
                            )
                        }
                }
            }
    }
    
    private func drawWeeklyItem(_ flex: Flex, weekdayText: String, minTemp: Double, maxTemp: Double, rainChance: Int?, iconImage: UIImage?) {
        let weekday: UILabel = UILabel()
        weekday.font = .en14
        weekday.text = weekdayText
        flex.addItem(weekday)
        
        flex.addItem()
            .justifyContent(.end)
            .alignItems(.center)
            .direction(.row)
            .define { flex in
                let weatherImage: UIImageView = UIImageView()
                let temp: UILabel = UILabel()
                
                temp.font = .en14
                temp.text = String(format: "%.0f%@  %.0f%@", minTemp, C.weatherUnit.tempUnit, maxTemp, C.weatherUnit.tempUnit)
                
                if let rainChance = rainChance {
                    flex.addItem()
                        .direction(.row)
                        .alignItems(.center)
                        .width(42)
                        .justifyContent(.spaceBetween)
                        .define { flex in
                            let pop: UILabel = UILabel()
                            pop.font = .en12
                            pop.text = String(format: "%d%%", rainChance)
                            pop.textColor = .black.withAlphaComponent(0.82)
                            
                            let waterDrop: UIImageView = UIImageView()
                            waterDrop.image = UIImage(named: "water_drop")?.resized(toWidth: 10)
                            flex.addItem(waterDrop)
                            flex.addItem(pop)
                        }
                }
                
                weatherImage.contentMode = .scaleAspectFit
                weatherImage.image = iconImage
                
                flex.addItem(weatherImage).marginHorizontal(10)
                flex.addItem().direction(.row).justifyContent(.end).minWidth(60).define { flex in
                    temp.flex.grow(1)
                    flex.addItem(temp)
                }
            }
    }
    
    private func drawHourly(_ flex: Flex) {
        guard let current = self.item?.currentWeather, let hourly = self.item?.hourly else { return }
        flex.addItem(hourlyView)
            .backgroundColor(.white.withAlphaComponent(0.13))
            .cornerRadius(12)
            .marginTop(16)
            .define { flex in
                flex.addItem(hourlyScrollView)
                    .paddingVertical(14)
                    .define { flex in
                        flex.addItem(hourlyContentView)
                            .direction(.row)
                            .padding(0)
                            .justifyContent(.start)
                            .alignItems(.center)
                            .define { flex in
                                hourly.forEach { item in
                                    flex.addItem()
                                        .direction(.column)
                                        .justifyContent(.center)
                                        .alignItems(.center)
                                        .padding(0, 14)
                                        .define { flex in
                                            let time: UILabel = UILabel()
                                            let image: UIImageView = UIImageView()
                                            let temp: UILabel = UILabel()
                                            
                                            time.font = .en14
                                            time.text = "\(Utils.intervalToHour(item.dt))"
                                            
                                            temp.font = .en14
                                            temp.text = String(format: "%.0f%@", item.temp, C.weatherUnit.tempUnit)
                                            
                                            
                                            image.contentMode = .scaleAspectFit
                                            image.image = item.iconImage(34.0)
                                            
                                            
                                            flex.addItem(time).paddingBottom(8)
                                            flex.addItem(image).paddingBottom(4)
                                            flex.addItem(temp).paddingBottom(8)
                                            flex.addItem()
                                                .direction(.row)
                                                .alignItems(.center)
                                                .define { flex in
                                                    let pop: UILabel = UILabel()
                                                    let waterDrop: UIImageView = UIImageView()
                                                    pop.font = .en12
                                                    pop.text = String(format: "%d%%", item.pop)
                                                    waterDrop.image = UIImage(named: "water_drop")?.resized(toWidth: 10)
                                                    flex.addItem(waterDrop).marginRight(2)
                                                    flex.addItem(pop)
                                                }
                                        }
                                }
                            }
                    }
            }
    }
    
    private func drawHeader(_ flex: Flex) {
        guard let location = self.item?.location, let current = self.item?.currentWeather, let today = self.item?.daily.first else { return }
        flex.addItem()
            .direction(.column)
            .padding(0)
            .define { flex in
                flex.addItem()
                    .direction(.row)
                    .justifyContent(.spaceBetween)
                    .padding(0)
                    .define { flex in
                        // Header
                        flex.addItem()
                            .shrink(1)
                            .direction(.column)
                            .define { flex in
                                let currentTempLabel: UILabel = UILabel()
                                let currentDescriptionLabel: UILabel = UILabel()
                                
                                currentTempLabel.font = .en48
                                currentTempLabel.text = String(format: "%.1f%@", current.temp, C.weatherUnit.tempUnit)
                                
                                currentDescriptionLabel.font = .en20
                                currentDescriptionLabel.text = current.weather.first?.description
                                currentDescriptionLabel.numberOfLines = 0
                                flex.addItem(currentTempLabel)
                                flex.addItem(currentDescriptionLabel)
                            }
                        flex.addItem()
                            .direction(.row)
                            .define { flex in
                                let currentWeatherImage1: UIImageView = UIImageView()
                                let isHasSeveralWeather: Bool = current.weather.count > 1
                                currentWeatherImage1.contentMode = .scaleAspectFit
                                currentWeatherImage1.image = current.iconImage(isHasSeveralWeather ? 70.0 : 80.0)
                                currentWeatherImage1.flex.view?.pin.left()
                                
                                flex.addItem(currentWeatherImage1).alignSelf(.start)
                                
                                if isHasSeveralWeather {
                                    let currentWeatherImage2: UIImageView = UIImageView()
                                    currentWeatherImage2.contentMode = .scaleAspectFit
                                    currentWeatherImage2.image = current.iconImageSecond(isHasSeveralWeather ? 70.0 : 80.0)
                                    currentWeatherImage2.flex.view?.pin.left()
                                    
                                    flex.addItem(currentWeatherImage2).alignSelf(.start)
                                }
                            }
                    }
                let locationLabel: UILabel = UILabel()
                let tempDescription: UILabel = UILabel()
                locationLabel.font = .en16
                locationLabel.text = location.name
                
                flex.addItem()
                    .direction(.row)
                    .marginTop(20)
                    .define { flex in
                        flex.addItem(locationLabel)
                        if location.isCurrent {
                            let locationImage: UIImageView = UIImageView()
                            locationImage.contentMode = .scaleAspectFit
                            locationImage.image = UIImage(systemName: "location.fill")?.resized(toWidth: 13)
                            flex.addItem(locationImage).marginLeft(4)
                        }
                    }
                
                tempDescription.font = .en16
                tempDescription.text = "tempDescription".localized([
                    today.temp.min, C.weatherUnit.tempUnit,
                    today.temp.max, C.weatherUnit.tempUnit,
                    current.feels_like, C.weatherUnit.tempUnit
                ])
                flex.addItem(tempDescription).marginTop(2)
            }
    }
}

