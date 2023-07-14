//
//  ViewControllerRepresentable.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/11.
//

import Foundation
import SwiftUI

struct ViewControllerRepresentable<T: UIViewController>: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> T {
        return UIViewControllerType()
    }
    
    func updateUIViewController(_ uiViewController: T, context: Context) {
        
    }
}
