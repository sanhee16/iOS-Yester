////
////  SampleViewController.swift
////  WeatherApp
////
////  Created by sandy on 2023/07/15.
////
//
//import UIKit
//import SwiftUI
//import Combine
//
//class SampleViewController: BaseViewController {
//    typealias VM = SampleViewModel
//    
//    private let label: UILabel = UILabel()
//    private let vm: VM
//    private let userNameField: UITextField = UITextField()
//    private var userName: CurrentValueSubject = CurrentValueSubject<String, Never>("")
//    private let button: UIButton = UIButton()
//    
//    
//    init(vm: VM) {
//        self.vm = vm
//        super.init()
//        self.bind(to: vm)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func bind(to vm: VM) {
//        let input = VM.Input(userName: userName.eraseToAnyPublisher())
//        let output = vm.transform(input: input)
//        
//        output.isUserCreateButtonAvailable
//            .sink {[weak self] isEnabled in
//                guard let self = self else { return }
//                self.button.isEnabled = isEnabled
//                print("isEnabled? :\(isEnabled)")
//                self.label.text = isEnabled ? "생성 가능" : "이름 입력중..."
//            }
//            .store(in: &self.cancellables)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white // 배경색
//        
//        // 코드로 AutoLayout을 설정하기 전에, 먼저 SuperView를 설정하는 addSubView작업이 선행되어 있어야 함
//        self.addSubViews()
//        
//        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        label.textAlignment = .center
//        
//        
//        userNameField.placeholder = "이름"
//        
//        userNameField.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
//        userNameField.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
//        userNameField.trailingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
//        
//        userNameField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
//        userNameField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
//        button.isEnabled = false
//        
//        button.setTitle("생성하기", for: .normal)
//        button.setTitleColor(.systemPink, for: .normal)
//        button.setTitleColor(.gray, for: .disabled)
//        
//        button.topAnchor.constraint(equalTo: userNameField.bottomAnchor).isActive = true
//        button.leadingAnchor.constraint(equalTo: userNameField.leadingAnchor).isActive = true
//        button.trailingAnchor.constraint(equalTo: userNameField.trailingAnchor).isActive = true
//        
//        button.addTarget(self, action: #selector(self.onCreateUser), for: .touchUpInside)
//    }
//    
//    private func addSubViews() {
//        self.view.addSubview(label)
//        self.view.addSubview(userNameField)
//        self.view.addSubview(button)
//        
//        // translatesAutoresizingMaskIntoConstraints == false => AutoLayout을 따르겠다
//        label.translatesAutoresizingMaskIntoConstraints = false
//        userNameField.translatesAutoresizingMaskIntoConstraints = false
//        button.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    @objc private func textFieldDidChange(sender: UITextField) {
//        switch sender {
//        case userNameField:
//            userName.send(sender.text!)
//        default: break
//        }
//    }
//    
//    @objc private func onCreateUser() {
//        label.text = "생성완료"
//        userName.send(completion: .finished)
//        button.isHidden = true
//    }
//    
//}
