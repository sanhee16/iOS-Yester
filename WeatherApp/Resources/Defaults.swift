//
//  Defaults.swift
//  WeatherApp
//
//  Created by sandy on 2023/08/04.
//

import Foundation

@propertyWrapper struct UserDefault<T: Codable> {
    private let key: String
    private let defaultValue: T
    
    var wrappedValue: T {
//        get { (UserDefaults.standard.object(forKey: self.key) as? T) ?? self.defaultValue }
//        set { UserDefaults.standard.setValue(newValue, forKey: key) }
        
        get {
            if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let lodedObejct = try? decoder.decode(T.self, from: savedData) {
                    return lodedObejct
                }
            }
            return defaultValue
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.setValue(encoded, forKey: key)
            }
        }
    }
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

class Defaults {
    @UserDefault<Bool>(key: "FIRST_LAUNCH", defaultValue: true)
    public static var firstLaunch
    
    @UserDefault<[Location]>(key: "LOCATIONS", defaultValue: [])
    public static var locations
    
    @UserDefault<Int>(key: "WEATHER_UNIT", defaultValue: WeatherUnit.metric.rawValue)
    public static var weatherUnit
    
    @UserDefault<Int>(key: "INTERSTITIAL_COUNT", defaultValue: 0)
    public static var interstitialCount
    
    @UserDefault<Int>(key: "LAST_CALL_API_IDX", defaultValue: 0)
    public static var lastCallApiIdx
}
