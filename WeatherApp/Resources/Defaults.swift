//
//  Defaults.swift
//  WeatherApp
//
//  Created by sandy on 2023/08/04.
//

import Foundation

@propertyWrapper struct UserDefault<T> {
    private let key: String
    private let defaultValue: T
    
    var wrappedValue: T {
        get { (UserDefaults.standard.object(forKey: self.key) as? T) ?? self.defaultValue }
        set { UserDefaults.standard.setValue(newValue, forKey: key) }
    }
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

class Defaults {
    @UserDefault<Bool>(key: "FIRST_LAUNCH", defaultValue: true)
    public static var firstLaunch
}
