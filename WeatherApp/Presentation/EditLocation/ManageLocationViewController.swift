//
//  ManageLocationViewController.swift
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
 삭제
 추가
 순서 변경
*/
class ManageLocationViewController: BaseViewController {
    typealias VM = ManageLocationViewModel
    
    private let vm: VM
    
    fileprivate lazy var rootFlexContainer: UIView = UIView()
    fileprivate lazy var scrollView: UIScrollView = UIScrollView()
    fileprivate lazy var contentView: UIView = UIView()

    var locations: [Location] = []
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
        
        vm.locations.observe(on: self) {[weak self] locations in
            guard let self = self else { return }
            print("[ML] locations: \(locations)")
            self.locations = locations
            self.setLayout()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "manage_locations".localized()
        
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
        rootFlexContainer.flex.layout()
        
        // scrollView
        scrollView.pin.all()
        
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = contentView.frame.size
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func setLayout() {
        //addChild: self.lottieVC(VC)를 현재 VC(MainVC)의 자식으로 설정
        self.addChild(self.lottieVC)
        
        //addSubview: 추가된 childVC의 View가 보일 수 있도록 맨 앞으로 등장하게 하는 것
        view.addSubview(rootFlexContainer)
        view.addSubview(self.lottieVC.view)
        view.backgroundColor = .backgroundColor
        
        rootFlexContainer.flex
            .direction(.column)
            .justifyContent(.start)
            .define { flex in
                flex.addItem(scrollView)
                    .define { flex in
                        flex.addItem(contentView)
                            .direction(.column)
                            .justifyContent(.start)
                            .define { flex in
                                for idx in self.locations.indices {
                                    locationItem(flex, location: self.locations[idx])
                                    if idx < self.locations.count - 1 {
                                        divider(flex)
                                    }
                                }
                            }
                    }
            }
    }
    
    private func divider(_ flex: Flex) {
        flex.addItem()
            .padding(0, 14)
            .define { flex in
                let view = UIView()
                view.backgroundColor = .black.withAlphaComponent(0.1)
                view.pin.width(100%).height(1)
                flex.addItem(view)
            }
    }
    
    private func locationItem(_ flex: Flex, location: Location) {
        flex.addItem()
            .direction(.row)
            .justifyContent(.spaceBetween)
            .padding(7, 14)
            .define { flex in
                let name: UILabel = UILabel()
                name.text = location.name
                name.font = .en16r
                
                let delete: UIButton = UIButton()
                let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .large)
                let image: UIImage? = UIImage(systemName: "x.circle.fill", withConfiguration: config)?.withTintColor(.primeColor2, renderingMode: .alwaysOriginal)
                delete.setImage(image, for: .normal)
                delete.addTarget(self, action: #selector(self.onClickDelete), for: .touchUpInside)
                delete.flex.padding(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 0))

                flex.addItem(name)
                flex.addItem(delete)
            }
    }
    
    @objc
    private func onClickDelete() {
        vm.onClickDelete()
    }
}
