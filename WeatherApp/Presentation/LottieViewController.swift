//
//  LottieViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/08/04.
//

import Foundation
import UIKit
import Lottie
 

enum LottieType: String {
    case progressing = "progressing"
    case splash = "splash"
}

class LottieVC: UIViewController {
    let animationView: LottieAnimationView
    
    init(type: LottieType) {
        self.animationView = .init(name: type.rawValue)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(animationView)
        
        animationView.frame = self.view.bounds
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFit
        
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.8
        animationView.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animationView.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        animationView.stop()
    }
}
