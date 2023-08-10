//
//  MainViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/10.
//

import UIKit
import SwiftUI
import Combine
import SnapKit


class MainViewController: BaseViewController {
    typealias VM = MainViewModel
    
    private let vm: VM
    
    var pageVC: UIPageViewController
    var pages: [WeatherCardViewController]
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
        
        vm.isProgressing.observe(on: self) { [weak self] isProgressing in
            guard let self = self else { return }
            self.lottieVC.view.isHidden = !isProgressing
            self.pageVC.view.isHidden = isProgressing
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubViews()
        vm.viewDidLoad()
        
        self.view.backgroundColor = .primeColor2
        
        self.pageVC.view.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(40)
        }
        
        self.lottieVC.view.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func loadPages() {
        self.pageVC.dataSource = nil
        self.pageVC.dataSource = self
        self.pageVC.delegate = self
        //TROUBLE_SHOOTING: 위 블럭과 아래 블럭 위치를 바꿨더니 데이터 업데이트가 안되었음
        if let startVC = self.pages.first {
            self.pageVC.setViewControllers([startVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vm.viewWillAppear()
        self.navigationItem.hidesBackButton = true
    }
    
    private func addSubViews() {
        self.addChild(self.pageVC)
        self.addChild(self.lottieVC)
        
        self.view.addSubview(self.pageVC.view)
        self.view.addSubview(self.lottieVC.view)
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
            print("complete: \(self.currentIdx)")
        }
    }
}
