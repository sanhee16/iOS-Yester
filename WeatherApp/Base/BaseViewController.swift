//
//  BaseViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/15.
//

import Foundation
import Combine
import UIKit

class BaseViewController: UIViewController {
    var subscription: Set<AnyCancellable> = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    // 필수 생성자로, 슈퍼 클래스에서 정의해둘 경우 서브 클래스가 슈퍼 클래스의 생성자를 상속받지 않는 한 서브클래스에서 반드시 구현해주어야 함
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor // 배경색
        
        // backButton에 text(뒤로) 제거하기
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        subscription.forEach {
            $0.cancel()
        }
    }
}
