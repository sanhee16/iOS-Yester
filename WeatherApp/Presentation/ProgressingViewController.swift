//
//  ProgressingViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/08/04.
//

import Foundation
import UIKit
import Lottie
 
class ProgressingViewController: UIViewController {
    let animationView: LottieAnimationView = .init(name: "progressing")
 
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
