//
//  SettingViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/09/06.
//

import UIKit
import SwiftUI
import Combine
import PinLayout
import FlexLayout

/*
 단위 변경
 
 별점
 버전 정보
*/

class SettingViewController: BaseViewController {
    typealias VM = SettingViewModel
    
    private let vm: VM
    
    fileprivate lazy var rootFlexContainer: UIView = UIView()
    
    // scroll
    fileprivate lazy var scrollView: UIScrollView = UIScrollView()
    fileprivate lazy var contentView: UIView = UIView()
    
    fileprivate lazy var selectUnit: SettingItem1 = SettingItem1()
    fileprivate lazy var appVersion: SettingItem1 = SettingItem1()
    
    var lottieVC: LottieVC = {
        let lottieVC = LottieVC(type: .progressing)
        lottieVC.modalPresentationStyle = .overFullScreen
        lottieVC.modalTransitionStyle = .crossDissolve
        lottieVC.view.backgroundColor = .clear
        return lottieVC
    }()
    
    init(vm: VM) {
        self.vm = vm
        
        super.init()
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        vm.isLoading.observe(on: self) {[weak self] isLoading in
            DispatchQueue.main.asyncAfter(deadline: .now() + (isLoading ? 0.0 : 0.6) ) { [weak self] in
                self?.lottieVC.view.isHidden = !isLoading
            }
        }
        vm.unitText.observe(on: self) {[weak self] text in
            guard let self = self else { return }
            self.selectUnit.configure(vm: self.vm, title: "unit".localized(), descriptionText: text, onClick: onClickUnit)
            self.layout()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "setting".localized()
        
        selectUnit.configure(vm: self.vm, title: "unit".localized(), descriptionText: C.weatherUnit.unitText, onClick: onClickUnit)
        appVersion.configure(vm: self.vm, title: "app_version".localized(), descriptionText: (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String))
        
        self.setLayout()
        
        vm.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.viewWillAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexContainer.pin.all(view.pin.safeArea)
        
        // cardScrollView
        scrollView.pin.all()
        
        scrollView.contentSize = contentView.frame.size
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        self.layout()
    }
    
    private func layout() {
        rootFlexContainer.flex.layout()
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    private func setLayout() {
        //addChild: self.lottieVC(VC)를 현재 VC(MainVC)의 자식으로 설정
        self.addChild(self.lottieVC)
        
        //addSubview: 추가된 childVC의 View가 보일 수 있도록 맨 앞으로 등장하게 하는 것
        view.addSubview(rootFlexContainer)
        view.addSubview(self.lottieVC.view)
        view.backgroundColor = .backgroundColor
        
        rootFlexContainer.flex
            .justifyContent(.start)
            .alignItems(.center)
            .define { flex in
                flex.addItem(scrollView)
                    .width(100%)
                    .define { flex in
                        flex.addItem(contentView)
                            .width(100%)
                            .define { flex in
                                flex.addItem(SettingTitle(title: "title1", descriptionText: "description"))
                                flex.addItem(selectUnit).markDirty()
                                flex.addItem(appVersion).markDirty()
                            }
                    }
            }
    }
    
    @objc
    func onClickUnit() {
        vm.onClickUnit()
    }
    
}
