//
//  SelectUnitViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/08/22.
//

import Foundation
import UIKit
import SwiftUI
import Combine
import PinLayout
import FlexLayout

class SelectUnitViewController: BaseViewController {
    typealias VM = SelectUnitViewModel
    
    private let vm: VM
    
    fileprivate lazy var rootFlexContainer: UIView = UIView()
    
    
    fileprivate lazy var metricView: UIView = UIView()
    fileprivate lazy var imperialView: UIView = UIView()
    
    fileprivate lazy var metricLabel: UILabel = UILabel()
    fileprivate lazy var imperialLabel: UILabel = UILabel()

    init(vm: VM) {
        print("[UnitView] init")
        self.vm = vm
        super.init()
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        vm.unit.observe(on: self) { [weak self] unit in
            guard let self = self else { return }
            switch unit {
            case .metric:
                self.selected(view: metricView, label: metricLabel)
                self.unselected(view: imperialView, label: imperialLabel)
                break
            case .imperial:
                self.unselected(view: metricView, label: metricLabel)
                self.selected(view: imperialView, label: imperialLabel)
                break
            }
        }
    }
    
    private func unselected(view: UIView, label: UILabel) {
        view.backgroundColor = .white
        view.flex.border(1.6, .black.withAlphaComponent(0.15))
        
        label.textColor = .black.withAlphaComponent(0.6)
    }
    
    private func selected(view: UIView, label: UILabel) {
        view.backgroundColor = .primeColor2.withAlphaComponent(0.6)
        view.flex.border(1.6, .black.withAlphaComponent(0.7))
        
        label.textColor = .black
    }
    
    override func viewDidLoad() {
        print("[UnitView] viewDidLoad")
        super.viewDidLoad()
        
        vm.viewDidLoad()
        self.setLayout()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexContainer.pin
            .vCenter()
            .hCenter()
            .width(80%).height(470)
        rootFlexContainer.flex.layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.viewWillAppear()
    }
    
    private func setLayout() {
        print("[UnitView] setLayout")
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.backgroundColor(.white)
        rootFlexContainer.flex.cornerRadius(20)
        
        rootFlexContainer.flex
            .padding(12, 16)
            .direction(.column)
            .justifyContent(.spaceAround)
            .define { flex in
                let title: UILabel = UILabel()
                title.font = .en20b
                title.text = "select_unit".localized()
                title.textColor = .black
                flex.addItem(title).margin(16, 0, 30)
                
                drawUnit(flex, unit: .metric, label: metricLabel, unitView: metricView)
                drawUnit(flex, unit: .imperial, label: imperialLabel, unitView: imperialView)
                
                drawSaveButton(flex)
            }
    }
    
    private func drawUnit(_ flex: Flex, unit: WeatherUnit, label: UILabel, unitView: UIView) {
        flex.addItem()
            .direction(.column)
            .width(100%)
            .marginBottom(20)
            .define { flex in
                drawUnitTitle(flex, unit: unit, label: label)
                drawUnitButton(flex, unit: unit, unitView: unitView)
            }
    }
    
    private func drawUnitTitle(_ flex: Flex, unit: WeatherUnit, label: UILabel) {
        flex.addItem()
            .direction(.column)
            .marginBottom(10)
            .define { flex in
                label.font = .en18b
                label.text = unit.unitText
                label.textColor = .black
                
                flex.addItem(label)
                    .paddingBottom(6)
            }
    }
    
    private func drawUnitButton(_ flex: Flex, unit: WeatherUnit, unitView: UIView) {
        flex.addItem(unitView)
            .direction(.column)
            .width(100%)
            .cornerRadius(8.0)
            .padding(12, 16)
            .define { flex in
                flex.addItem()
                    .direction(.row)
                    .width(100%)
                    .justifyContent(.spaceBetween)
                    .define { flex in
                        let title: UILabel = UILabel()
                        let description: UILabel = UILabel()
                        
                        title.text = "temperature".localized()
                        description.text = unit.tempDescription
                        
                        title.font = .en16b
                        title.textColor = .black
                        description.font = .en14r
                        description.textColor = .black
                        
                        flex.addItem(title)
                        flex.addItem(description)
                    }
                flex.addItem()
                    .direction(.row)
                    .width(100%)
                    .justifyContent(.spaceBetween)
                    .marginTop(4)
                    .define { flex in
                        let title: UILabel = UILabel()
                        let description: UILabel = UILabel()
                        
                        title.text = "wind_speed".localized()
                        description.text = unit.windDescription
                        
                        title.font = .en16b
                        title.textColor = .black
                        description.font = .en14r
                        description.textColor = .black
                        
                        flex.addItem(title)
                        flex.addItem(description)
                    }
                
            }
        let tapGesture = CustomTapGestureRecognizer(target: self, action: #selector(self.onClickUnit), unit: unit)
        unitView.addGestureRecognizer(tapGesture)
    }
    
    private func drawSaveButton(_ flex: Flex) {
        flex.addItem()
            .margin(UIEdgeInsets(top: 40, left: 0, bottom: 16, right: 0))
            .define { flex in
                let saveBtn: UIButton = UIButton()
                
                saveBtn.layer.cornerRadius = 8.0
                saveBtn.backgroundColor = .primeColor2
                saveBtn.setTitle("save".localized(), for: .normal)
                saveBtn.addTarget(self, action: #selector(self.onClickSave), for: .touchUpInside)
                
                flex.addItem(saveBtn)
                    .paddingVertical(6)
            }
    }
    
    @objc func onClickSave() {
        self.presentInterstitialAd {[weak self] in
            self?.vm.onClickSave()
        }
    }
    
    @objc func onClickUnit(sender: CustomTapGestureRecognizer) {
        vm.onClickUnit(unit: sender.unit)
    }
    
    
    class CustomTapGestureRecognizer: UITapGestureRecognizer {
        let unit: WeatherUnit
        init(target: Any?, action: Selector?, unit: WeatherUnit) {
            self.unit = unit
            super.init(target: target, action: action)
        }
    }
    
}
