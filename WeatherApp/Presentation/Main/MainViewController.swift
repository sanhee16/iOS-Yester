//
//  MainViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/10.
//

import UIKit
import SwiftUI
import Combine
//import SnapKit
import PinLayout
import FlexLayout


class MainViewController: BaseViewController {
    typealias VM = MainViewModel
    
    private let vm: VM
    
    fileprivate lazy var rootFlexContainer: UIView = UIView()
    fileprivate var pageVC: UIPageViewController
    fileprivate var pages: [WeatherCardViewController]
    var currentIdx: Int {
        guard let vc = pageVC.viewControllers?.first else { return 0 }
        return pages.firstIndex(of: vc as! WeatherCardViewController) ?? 0
    }
    
    var lottieVC: LottieVC = {
        let lottieVC = LottieVC(type: .progressing)
        return lottieVC
    }()
    
    
    init(vm: VM) {
        self.vm = vm
        self.pages = []
        let options: [UIPageViewController.OptionsKey : Any] = [
            .interPageSpacing: 20,
            .spineLocation: UIPageViewController.SpineLocation.mid
        ]
        self.pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
        
        super.init()
        self.bind(to: vm)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(to vm: VM) {
        vm.items.observe(on: self) { [weak self] items in
            guard let self = self else { return }
            self.pages.removeAll()
            items.forEach { item in
                self.pages.append(WeatherCardViewController(vm: vm, item: item))
            }
            self.pages.append(WeatherCardViewController(vm: vm, item: nil))
            self.loadPages()
        }
        
        vm.onCompleteLoadPage.observe(on: self) { [weak self] isComplete in
            guard let self = self else { return }
            if isComplete {
                self.loadPages()
            }
        }
        
        vm.isProgressing.observe(on: self) { [weak self] isProgressing in
            guard let self = self else { return }
            self.lottieVC.view.isHidden = !isProgressing
            self.pageVC.view.isHidden = isProgressing
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.setLayout()
        
        vm.viewDidLoad()
    }
    
    private func setLayout() {
        //addChild: self.lottieVC(VC)를 현재 VC(MainVC)의 자식으로 설정
        self.addChild(self.lottieVC)
        self.addChild(self.pageVC)
        
        //addSubview: 추가된 childVC의 View가 보일 수 있도록 맨 앞으로 등장하게 하는 것
        view.addSubview(rootFlexContainer)
        view.addSubview(self.lottieVC.view)
        
        view.backgroundColor = .primeColor2
        
        rootFlexContainer.flex
            .justifyContent(.center)
            .alignItems(.center)
            .define { flex in
                flex.addItem(self.pageVC.view)
            }
    }
    
    private func loadPages() {
        // BLOCK 1
        self.pageVC.dataSource = nil
        self.pageVC.dataSource = self
        self.pageVC.delegate = self
        
        self.pageVC.setViewControllers([self.pages[currentIdx]], direction: .forward, animated: false, completion: nil)
    }
    
    private func moveFirstPage() {
        // BLOCK 2
        //[TROUBLE_SHOOTING]: 위 블럭(Block1)과 아래 블럭(Block2) 위치를 바꿨더니 데이터 업데이트가 안되었음
        if let startVC = self.pages.first {
            self.pageVC.setViewControllers([startVC], direction: .forward, animated: true) { isComplete in
                startVC.viewWillAppear(true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vm.viewWillAppear()
        
        // 1. container의 Layout을 먼저 잡아줌
        rootFlexContainer.pin.all(view.pin.safeArea)
        
        // 2. flexbox child를 layout한다(child의 layout을 잡아준다).
        // default is '.fitContainer'. 자식뷰들이 컨테이너의 크기 안에 배치(child는 container의 크기(width, height)내에 배치된다).
        rootFlexContainer.flex.layout()
    }
}

extension MainViewController: UIPageViewControllerDataSource {
    // 현재 페이지 뷰의 이전 뷰를 미리 로드
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if self.currentIdx <= 0 {
            return nil
        }
        let previousIndex = self.currentIdx - 1
        return self.pages[previousIndex]
    }
    
    // 현재 페이지 뷰의 다음 뷰를 미리 로드
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if self.currentIdx >= self.pages.count - 1 {
            return nil
        }
        let nextIdx = self.currentIdx + 1
        if self.pages[nextIdx].item != nil {
            vm.updateWeather(vm.items.value[nextIdx])
        }
        return self.pages[nextIdx]
    }
    
    
    // 인디케이터의 개수
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    // 인디케이터의 초기 값
    func presentationIndex(for _: UIPageViewController) -> Int {
        return 0
    }
}

extension MainViewController: UIPageViewControllerDelegate {
    // 현재 페이지 로드가 끝났을 때
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if self.pages[self.currentIdx].item == nil { return }
        }
    }
}
