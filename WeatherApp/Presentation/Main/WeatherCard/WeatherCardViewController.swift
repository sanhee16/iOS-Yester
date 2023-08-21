//
//  WeatherCardViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/17.
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
    
    let addButton: UIButton = UIButton()
    
    fileprivate lazy var rootFlexContainer: UIView = UIView()
    
    // Card
    fileprivate lazy var cardScrollView: UIScrollView = UIScrollView()
    fileprivate lazy var cardContentView: UIView = UIView()
    
    // Header
    private lazy var currentTempLabel: UILabel = UILabel()
    private lazy var currentDescriptionLabel: UILabel = UILabel()
    private lazy var currentWeatherImage: UIImageView = UIImageView()
    private lazy var locationLabel: UILabel = UILabel()
    private lazy var tempDescription: UILabel = UILabel()
    
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
        hourlyScrollView.showsVerticalScrollIndicator = false
        hourlyScrollView.showsHorizontalScrollIndicator = false
    }
    
    private func setLayout() {
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.backgroundColor(.white.withAlphaComponent(0.13))
        rootFlexContainer.flex.cornerRadius(20)
        
        if let item = self.item, let currentWeather = item.currentWeather {
            let daily = item.daily
            let hourly = item.hourly
            let threeHourly = item.threeHourly
            
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
                                    drawHeader(flex, item: item, currentWeather: currentWeather, daily: daily)
                                    // 1Hour
                                    drawHourly(flex, item: item, hourly: hourly)
                                    // Weekly
                                    drawWeekly(flex, item: item, dailyList: daily)
                                    // Extra
                                    drawExtra(flex, item: item, currentWeather: currentWeather)
                                }
                            
                        }
                }
        } else {
            rootFlexContainer.flex
                .margin(0, 16)
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
    
    private func drawExtra(_ flex: Flex, item: WeatherCardItem, currentWeather: Current) {
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
                                name.font = .en18
                                name.text = String(format: "%@", "wind_speed".localized())

                                let value: UILabel = UILabel()
                                value.font = .en14
                                value.text = String(format: "%.0f m/s", currentWeather.windSpeed)

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
                                name.font = .en18
                                name.text = String(format: "%@", "uvi".localized())

                                let value: UILabel = UILabel()
                                value.font = .en14
                                value.text = String(format: "%@ (%d)", currentWeather.uvi.uviText(), currentWeather.uvi)

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
                                name.font = .en18
                                name.text = String(format: "%@", "humidity".localized())

                                let value: UILabel = UILabel()
                                value.font = .en14
                                value.text = String(format: "%d %%", currentWeather.humidity)

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
                                        name.font = .en18
                                        name.text = String(format: "%@", "sunrise".localized())

                                        let value: UILabel = UILabel()
                                        value.font = .en14
                                        value.text = String(format: "%@", Utils.intervalToHourMin(currentWeather.sunrise))

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
                                        name.font = .en18
                                        name.text = String(format: "%@", "sunset".localized())

                                        let value: UILabel = UILabel()
                                        value.font = .en14
                                        value.text = String(format: "%@", Utils.intervalToHourMin(currentWeather.sunset))

                                        flex.addItem(image)
                                        flex.addItem(name)
                                        flex.addItem(value)
                                    }
                            }
                    }
            }
    }
    
    private func drawWeekly(_ flex: Flex, item: WeatherCardItem, dailyList: [DailyWeather]) {
        flex.addItem()
            .direction(.column)
            .backgroundColor(.white.withAlphaComponent(0.13))
            .cornerRadius(12)
            .marginTop(16)
            .padding(6, 14, 10, 14)
            .define { flex in
                dailyList.forEach { daily in
                    flex.addItem()
                        .direction(.row)
                        .justifyContent(.spaceBetween)
                        .paddingTop(4)
                        .define { flex in
                            let weekday: UILabel = UILabel()
                            weekday.font = .en14
                            weekday.text = "\(Utils.intervalToWeekday(daily.dt))"
                            flex.addItem(weekday)
                            
                            flex.addItem()
                                .direction(.row)
                                .define { flex in
                                    let weatherImage: UIImageView = UIImageView()
                                    let temp: UILabel = UILabel()
                                    let pop: UILabel = UILabel()
                                    
                                    temp.font = .en14
                                    temp.text = String(format: "%.0f  %.0f", daily.temp.max, daily.temp.min)
                                    
                                    pop.font = .en14
                                    pop.text = String(format: "%2d%%", daily.pop)
                                    
                                    weatherImage.contentMode = .scaleAspectFit
                                    weatherImage.image = UIImage(named: daily.weather.first?.icon ?? "")?.resized(toWidth: 34.0)
                                    
                                    flex.addItem()
                                        .direction(.row)
                                        .alignItems(.center)
                                        .define { flex in
                                            let waterDrop: UIImageView = UIImageView()
                                            waterDrop.image = UIImage(named: "water_drop")?.resized(toWidth: 12)
                                            flex.addItem(waterDrop)
                                            flex.addItem(pop).paddingLeft(6)
                                        }
                                    flex.addItem(weatherImage).paddingLeft(12)
                                    flex.addItem(temp).paddingLeft(12)
                                }
                        }
                }
            }
    }
    
    private func drawHourly(_ flex: Flex, item: WeatherCardItem, hourly: [HourlyWeather]) {
        flex.addItem(hourlyView)
            .backgroundColor(.white.withAlphaComponent(0.13))
            .cornerRadius(12)
            .marginTop(16)
            .define { flex in
                flex.addItem(hourlyScrollView)
                    .define { flex in
                        flex.addItem(hourlyContentView)
                            .direction(.row)
                            .padding(0)
                            .justifyContent(.start)
                            .alignItems(.center)
                            .define { flex in
                                hourly.indices.forEach { idx in
                                    let item = hourly[idx]
                                    flex.addItem()
                                        .direction(.column)
                                        .justifyContent(.center)
                                        .alignItems(.center)
                                        .padding(0, 14)
                                        .define { flex in
                                            let time: UILabel = UILabel()
                                            let image: UIImageView = UIImageView()
                                            let temp: UILabel = UILabel()
                                            let pop: UILabel = UILabel()
                                            
                                            time.font = .en14
                                            time.text = "\(Utils.intervalToHour(item.dt))"
                                            
                                            temp.font = .en14
                                            temp.text = String(format: "%.0f", item.temp)
                                            
                                            pop.font = .en14
                                            pop.text = String(format: "%d%%", item.pop)
                                            
                                            image.contentMode = .scaleAspectFit
                                            image.image = UIImage(named: item.weather.first?.icon ?? "")?.resized(toWidth: 34.0)
                                            
                                            flex.addItem(time).paddingBottom(6)
                                            flex.addItem(image).paddingBottom(6)
                                            flex.addItem(temp).paddingBottom(4)
                                            flex.addItem()
                                                .direction(.row)
                                                .alignItems(.center)
                                                .define { flex in
                                                    let waterDrop: UIImageView = UIImageView()
                                                    waterDrop.image = UIImage(named: "water_drop")?.resized(toWidth: 12)
                                                    flex.addItem(waterDrop).paddingLeft(4)
                                                    flex.addItem(pop)
                                                }
                                        }
                                }
                            }
                    }
            }
    }
    
    private func drawHeader(_ flex: Flex, item: WeatherCardItem, currentWeather: Current, daily: [DailyWeather]) {
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
                                    locationImage.image = UIImage(systemName: "location.fill")?.resized(toWidth: 13)
                                    flex.addItem(locationImage).marginLeft(4)
                                }
                            }
                        
                        tempDescription.font = .en16
                        tempDescription.text = "tempDescription".localized([daily.first?.temp.min ?? 0.0, daily.first?.temp.max ?? 0.0, currentWeather.feels_like])
                        //                        tempDescription.text = String(format: "%.1f / %.1f  체감 온도 %.1f", daily.first?.temp.min ?? 0.0, daily.first?.temp.max ?? 0.0, currentWeather.feels_like)
                        flex.addItem(tempDescription).marginTop(2)
                    }
                flex.addItem(currentWeatherImage).alignSelf(.start)
            }
    }
}
