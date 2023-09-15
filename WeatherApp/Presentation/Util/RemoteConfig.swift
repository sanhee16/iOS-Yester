//
//  RemoteConfig.swift
//  WeatherApp
//
//  Created by sandy on 2023/09/15.
//

import Foundation
import FirebaseRemoteConfig

enum RemoteConfigKey: String {
    case isShowBannerAds = "isShowBannerAds"
    case isShowInterstitialAds = "isShowInterstitialAds"
    case isShowMainBannerAds = "isShowMainBannerAds"
}

class Remote {
    static let shared: Remote = Remote()
    private let remoteConfig: RemoteConfig
    var isShowBannerAds: Bool = false
    var isShowInterstitialAds: Bool = false
    var isShowMainBannerAds: Bool = false
    
    private init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.setDefaults(fromPlist: "remote_config_defaults")
        
        self.updateListen()
        self.getValues()
    }
    
    private func getValues() {
        getRemoteBoolValue("isShowBannerAds") {[weak self]value in
            print("[RemoteConfig] \("isShowBannerAds"): \(value)")
            self?.isShowBannerAds = value
        }
        getRemoteBoolValue("isShowInterstitialAds") {[weak self]value in
            print("[RemoteConfig] \("isShowInterstitialAds"): \(value)")
            self?.isShowInterstitialAds = value
        }
        getRemoteBoolValue("isShowMainBannerAds") {[weak self]value in
            print("[RemoteConfig] \("isShowMainBannerAds"): \(value)")
            self?.isShowMainBannerAds = value
        }
    }
    
    private func getRemoteBoolValue(_ key: String, callback: @escaping (Bool)->()) {
        self.remoteConfig.fetch() { (status, error) -> Void in
            if status == .success {
                self.remoteConfig.activate() { (changed, error) in
                    let value = self.remoteConfig[key].boolValue
                    callback(value)
                    print("resultValue=", value)
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "No error available.")")
                callback(false)
            }
        }
    }
    
    private func updateListen() {
        remoteConfig.addOnConfigUpdateListener { configUpdate, error in
            guard let configUpdate, error == nil else {
                return
            }
            
            print("[RemoteConfig] Updated keys: \(configUpdate.updatedKeys)")
            
            self.remoteConfig.activate { changed, error in
                guard error == nil else { return }
                DispatchQueue.main.async {
                    self.getValues()
                }
            }
        }
    }
}
