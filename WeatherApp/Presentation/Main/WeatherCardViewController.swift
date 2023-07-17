//
//  WeatherCardViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/17.
//

import Foundation
import UIKit


class WeatherCardViewController: UIViewController {
    let location: Location?
    
    let addButton: UIButton = UIButton()
    let info: UILabel = UILabel()
    
    init(location: Location?) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = [.red, .yellow, .green, .blue, .brown, .purple].randomElement() ?? .orange
        if let location = self.location {
            self.view.addSubview(info)
            self.info.translatesAutoresizingMaskIntoConstraints = false
            
            self.info.text = "lat: \(String(format: "%0.3f", location.lat)) // lon: \(String(format: "%0.3f", location.lon)) // isStar: \(location.isStar)"
            self.info.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
            self.info.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
            self.info.textAlignment = .center
            self.info.numberOfLines = 0
        } else {
            self.view.addSubview(addButton)
            self.addButton.translatesAutoresizingMaskIntoConstraints = false
            self.addButton.isEnabled = true
            let addImage = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
            let addImageBold = UIImage(systemName: "plus", withConfiguration: addImage)?.withTintColor(.black, renderingMode: .alwaysOriginal)
            self.addButton.setImage(addImageBold, for: .normal)
            self.addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            self.addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            self.addButton.addTarget(self, action: #selector(self.onClickAdd), for: .touchUpInside)
        }
    }
    
    @objc func onClickAdd() {
        print("onClickAdd!")
    }
}
