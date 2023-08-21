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
    
    var item: WeatherCardItemV2?
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
    
    
    init(vm: VM, item: WeatherCardItemV2?) {
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
        
        if let item = self.item, let current = item.currentWeather {
            
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
                                    if let today = item.forecast {
                                        // HEADER
                                        drawHeader(flex, location: item.location, current: current, today: today)
                                        // 3Hour
                                        drawHourly(flex, current: current, today: today)
                                        // Extra
                                        drawExtra(flex, current: current, today: today)
                                    }
                                    // Weekly
//                                    drawWeekly(flex, item: item, dailyList: daily)
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
    
    private func drawExtra(_ flex: Flex, current: CurrentV2, today: ForecastV2) {
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
                                value.text = String(format: "%.0f k/h", current.wind_kph)

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
                                value.text = String(format: "%@ (%d)", current.uv.uviText(), current.uv)

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
                                        name.font = .en18
                                        name.text = String(format: "%@", "sunrise".localized())

                                        let value: UILabel = UILabel()
                                        value.font = .en14
                                        value.text = String(format: "%@", today.astro.sunrise)

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
                                        value.text = String(format: "%@", today.astro.sunset)

                                        flex.addItem(image)
                                        flex.addItem(name)
                                        flex.addItem(value)
                                    }
                            }
                    }
            }
    }
    /*
    private func drawWeekly(_ flex: Flex, item: WeatherCardItemV2, dailyList: [DailyWeather]) {
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
    */
    private func drawHourly(_ flex: Flex, current: CurrentV2, today: ForecastV2) {
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
                                today.hour.indices.forEach { idx in
                                    let item = today.hour[idx]
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
                                            time.text = "\(Utils.intervalToHour(item.time_epoch))"
                                            
                                            temp.font = .en14
                                            temp.text = String(format: "%.0f", item.temp_c)
                                            
                    
                                            image.contentMode = .scaleAspectFit
                                            image.image = item.iconImage()?.resized(toWidth: 34.0)
                                            
                                            flex.addItem(time).paddingBottom(6)
                                            flex.addItem(image).paddingBottom(6)
                                            flex.addItem(temp).paddingBottom(4)
                                            flex.addItem()
                                                .direction(.row)
                                                .alignItems(.center)
                                                .define { flex in
                                                    let pop: UILabel = UILabel()
                                                    let waterDrop: UIImageView = UIImageView()
                                                    pop.font = .en14
                                                    
                                                    if item.chance_of_snow > 0 {
                                                        pop.text = String(format: "%d%%", item.chance_of_snow)
                                                        waterDrop.image = UIImage(named: "13n")?.resized(toWidth: 12)
                                                    } else {
                                                        pop.text = String(format: "%d%%", item.chance_of_rain)
                                                        waterDrop.image = UIImage(named: "water_drop")?.resized(toWidth: 12)
                                                    }
                                                    
                                                    
                                                    flex.addItem(waterDrop).paddingLeft(4)
                                                    flex.addItem(pop)
                                                }
                                        }
                                }
                            }
                    }
            }
    }
    
    private func drawHeader(_ flex: Flex, location: Location, current: CurrentV2, today: ForecastV2) {
        flex.addItem()
            .direction(.row)
            .justifyContent(.spaceBetween)
            .padding(0)
            .define { flex in
                flex.addItem()
                    .direction(.column)
                    .define { flex in
                        currentTempLabel.font = .en38
                        currentTempLabel.text = String(format: "%.1f", current.temp_c)
                        
                        currentDescriptionLabel.font = .en20
                        currentDescriptionLabel.text = current.condition.text
                        
                        currentWeatherImage.contentMode = .scaleAspectFit
                        currentWeatherImage.image = current.iconImage()?.resized(toWidth: 80.0)
                        
                        locationLabel.font = .en16
                        locationLabel.text = location.name
                        
                        flex.addItem(currentTempLabel)
                        flex.addItem(currentDescriptionLabel)
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
                        tempDescription.text = "tempDescription".localized([today.day.mintemp_c, today.day.maxtemp_c, current.feelslike_c])
                        //                        tempDescription.text = String(format: "%.1f / %.1f  체감 온도 %.1f", daily.first?.temp.min ?? 0.0, daily.first?.temp.max ?? 0.0, currentWeather.feels_like)
                        flex.addItem(tempDescription).marginTop(2)
                    }
                flex.addItem(currentWeatherImage).alignSelf(.start)
            }
    }
}
