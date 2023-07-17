//
//  MainViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/10.
//

import UIKit
import SwiftUI
import Combine



class MainViewController: BaseViewController {
    typealias VM = MainViewModel
    
    private let vm: VM
    private var locations: [Location]
    
    var pageVC: UIPageViewController
    var pages: [WeatherCardViewController]
    var currentIdx: Int = 0
    
    init(vm: VM) {
        self.vm = vm
        self.locations = []
        self.pages = []
        self.pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        super.init()
        self.bind(to: vm)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(to vm: VM) {
        vm.locations.observe(on: self) { [weak self] locations in
            guard let self = self else { return }
            self.locations = locations
            print("observe: \(locations)")
            self.pages.removeAll()
            
            self.locations.forEach { location in
                self.pages.append(WeatherCardViewController(location: location))
            }
            self.pages.append(WeatherCardViewController(location: nil))
        }
    }
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        self.addSubViews()
        
        self.pageVC.dataSource = self
        self.pageVC.delegate = self
        
        let startVC = pages[self.currentIdx]
        let viewControllers = NSArray(object: startVC)
        
        self.pageVC.setViewControllers(viewControllers as? [UIViewController] , direction: .forward, animated: true, completion: nil)
        self.pageVC.view.frame = CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - (2.0 * 60.0))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        vm.viewWillAppear()
    }
    
    private func addSubViews() {
        self.addChild(self.pageVC)
        self.view.addSubview(self.pageVC.view)
        
        self.pageVC.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func onClickAddLocation() {
        print("onClickAddLocation")
        vm.onClickAdd()
    }
}

extension MainViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    // 현재 페이지 로드가 끝났을 때
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.currentIdx = self.pageVC.viewControllers?.first?.view.tag ?? 0
        }
    }

    // 현재 페이지 뷰의 이전 뷰를 미리 로드
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if self.currentIdx <= 0 {
            return nil
        }
        return pages[self.currentIdx - 1]
    }
    
    // 현재 페이지 뷰의 다음 뷰를 미리 로드
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if self.currentIdx >= self.locations.count - 1 {
            return nil
        }
        return pages[self.currentIdx + 1]
    }
}
