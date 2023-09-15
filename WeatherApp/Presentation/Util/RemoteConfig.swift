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
}

class Remote {
    static let shared: Remote = Remote()
    var remoteConfigList: [RemoteConfigKey: Any] = [:]
    private let remoteConfig: RemoteConfig
    
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
        self.isShowBannerAds {[weak self] value in
            self?.remoteConfigList[.isShowBannerAds] = value
        }
        self.isShowInterstitialAds {[weak self] value in
            self?.remoteConfigList[.isShowInterstitialAds] = value
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
    
    private func isShowBannerAds(_ callback: @escaping (Bool)->()) {
        getRemoteBoolValue("isShowBannerAds") { value in
            print("[RemoteConfig] isShowBannerAds: \(value)")
            callback(value)
        }
    }
    
    private func isShowInterstitialAds(_ callback: @escaping (Bool)->()) {
        getRemoteBoolValue("isShowInterstitialAds") { value in
            print("[RemoteConfig] isShowInterstitialAds: \(value)")
            callback(value)
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
