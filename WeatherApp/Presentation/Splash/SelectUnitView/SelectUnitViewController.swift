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
    fileprivate lazy var tempUnit0: UILabel = drawUnitButton(key: C.UNIT_TEMP, value: 0, text: TemperatureUnitV2(rawValue: 0)?.units)
    fileprivate lazy var tempUnit1: UILabel = drawUnitButton(key: C.UNIT_TEMP, value: 1, text: TemperatureUnitV2(rawValue: 1)?.units)
    fileprivate lazy var windUnit0: UILabel = drawUnitButton(key: C.UNIT_WIND, value: 0, text: WindUnitV2(rawValue: 0)?.units)
    fileprivate lazy var windUnit1: UILabel = drawUnitButton(key: C.UNIT_WIND, value: 1, text: WindUnitV2(rawValue: 1)?.units)
    fileprivate lazy var precUnit0: UILabel = drawUnitButton(key: C.UNIT_PREC, value: 0, text: PrecipitationUnitV2(rawValue: 0)?.units)
    fileprivate lazy var precUnit1: UILabel = drawUnitButton(key: C.UNIT_PREC, value: 1, text: PrecipitationUnitV2(rawValue: 1)?.units)
    
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
        vm.units.observe(on: self) { [weak self] units in
            guard let self = self else { return }
            units.forEach { (key: String, value: Int) in
                switch key {
                case C.UNIT_TEMP:
                    value == 0 ? self.changeStatus(selected: self.tempUnit0, unSelected: self.tempUnit1) : self.changeStatus(selected: self.tempUnit1, unSelected: self.tempUnit0)
                    break
                case C.UNIT_WIND:
                    value == 0 ? self.changeStatus(selected: self.windUnit0, unSelected: self.windUnit1) : self.changeStatus(selected: self.windUnit1, unSelected: self.windUnit0)
                    break
                case C.UNIT_PREC:
                    value == 0 ? self.changeStatus(selected: self.precUnit0, unSelected: self.precUnit1) : self.changeStatus(selected: self.precUnit1, unSelected: self.precUnit0)
                    break
                default:
                    break
                }
            }
        }
    }
    
    private func changeStatus(selected: UILabel, unSelected: UILabel) {
        selected.backgroundColor = .gray
        selected.layer.borderColor = UIColor.black.cgColor
        selected.textColor = UIColor.black
        
        unSelected.backgroundColor = .clear
        unSelected.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        unSelected.textColor = UIColor.black.withAlphaComponent(0.2)
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
            .width(80%)
            .height(70%)
        
        rootFlexContainer.flex.layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.viewWillAppear()
    }
    
    private func setLayout() {
        print("[UnitView] setLayout")
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.backgroundColor(.primeColor1)
        rootFlexContainer.flex.cornerRadius(20)
        
        rootFlexContainer.flex
            .padding(12, 16)
            .direction(.column)
            .justifyContent(.spaceAround)
            .define { flex in
                var title: UILabel = UILabel()
                title.font = .en20b
                title.text = "select_unit".localized()
                flex.addItem(title)
                    .paddingBottom(16)
                
                drawSelectUnits(flex, key: C.UNIT_TEMP, unit0: tempUnit0, unit1: tempUnit1)
                drawSelectUnits(flex, key: C.UNIT_WIND, unit0: windUnit0, unit1: windUnit1)
                drawSelectUnits(flex, key: C.UNIT_PREC, unit0: precUnit0, unit1: precUnit1)
                
                drawSaveButton(flex)
            }
    }
    
    private func drawSaveButton(_ flex: Flex) {
        flex.addItem()
            .paddingTop(12)
            .define { flex in
                var saveBtn: UIButton = UIButton()
                
                saveBtn.layer.cornerRadius = 8.0
                saveBtn.backgroundColor = .red
                saveBtn.setTitle("save".localized(), for: .normal)
                saveBtn.addTarget(self, action: #selector(self.onClickSave), for: .touchUpInside)
                
                flex.addItem(saveBtn)
                    .paddingVertical(10)
            }
    }
    
    private func drawSelectUnits(_ flex: Flex, key: String, unit0: UILabel, unit1: UILabel) {
        flex.addItem()
            .direction(.column)
            .define { flex in
                var subTitle: UILabel = UILabel()
                subTitle.font = .en18r
                subTitle.text = "temperature".localized()
                flex.addItem(subTitle)
                    .paddingBottom(6)
                flex.addItem()
                    .direction(.row)
                    .justifyContent(.spaceBetween)
                    .alignItems(.center)
                    .define { flex in
                        flex.addItem(unit0)
                            .width(100%)
                            .shrink(1)
                        
                        flex.addItem()
                            .width(20)
                        
                        flex.addItem(unit1)
                            .width(100%)
                            .shrink(1)
                    }
            }
    }
    
    private func drawUnitButton(key: String, value: Int, text: String?) -> UILabel {
        var unit: UILabel = UILabel()
        unit.font = .en16r
        unit.text = text ?? ""
        unit.backgroundColor = .gray
        unit.textAlignment = .center
        unit.flex.paddingVertical(14)
        unit.clipsToBounds = true
        unit.layer.cornerRadius = 8.0
        unit.layer.borderWidth = 2.0
        unit.layer.borderColor = UIColor.black.cgColor
        unit.isUserInteractionEnabled = true
        
        
        let tapGesture = CustomTapGestureRecognizer(target: self, action: #selector(self.onClickUnit), key: key, value: value)
        unit.addGestureRecognizer(tapGesture)
        
        return unit
    }
    
    @objc func onClickSave() {
        vm.onClickSave()
    }
    
    @objc func onClickUnit(sender: CustomTapGestureRecognizer) {
        vm.onClickUnit(key: sender.key, value: sender.value)
    }
    
    
    class CustomTapGestureRecognizer: UITapGestureRecognizer {
        let key: String
        let value: Int
        init(target: Any?, action: Selector?, key: String, value: Int) {
            self.key = key
            self.value = value
            super.init(target: target, action: action)
        }
    }
    
}
