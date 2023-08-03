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
    private var items: [WeatherItem]
    
    var pageVC: UIPageViewController
    var pages: [WeatherCardViewController]
    var currentIdx: Int {
        guard let vc = pageVC.viewControllers?.first else { return 0 }
        return pages.firstIndex(of: vc as! WeatherCardViewController) ?? 0
    }

    
    init(vm: VM) {
        self.vm = vm
        self.items = []
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
            if self.items == items {
                return
            }
            
            self.items = items
            self.pages.removeAll()
            self.items.forEach { item in
                self.pages.append(WeatherCardViewController(vm: vm, item: item))
            }
            self.pages.append(WeatherCardViewController(vm: vm, item: nil))
            
            self.reloadPages()
        }
    }
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        self.addSubViews()
        
        self.view.backgroundColor = .primeColor2
    }
    
    private func reloadPages() {
        print("reloadPages")
        self.pageVC.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        
        self.pageVC.view.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(40)
        }
        
        self.pageVC.dataSource = nil
        self.pageVC.dataSource = self
        self.pageVC.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vm.viewWillAppear()
    }
    
    private func addSubViews() {
        self.addChild(self.pageVC)
        self.view.addSubview(self.pageVC.view)
    }
}

extension MainViewController: UIPageViewControllerDataSource {
    // 현재 페이지 뷰의 이전 뷰를 미리 로드
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if self.currentIdx <= 0 {
            return nil
        }
        return pages[self.currentIdx - 1]
    }
    
    // 현재 페이지 뷰의 다음 뷰를 미리 로드
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if self.currentIdx >= self.pages.count - 1 {
            return nil
        }
        return pages[self.currentIdx + 1]
    }
}

extension MainViewController: UIPageViewControllerDelegate {
    // 현재 페이지 로드가 끝났을 때
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            print("complete: \(self.currentIdx)")
        }
    }
}
