//
//  BaseViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/15.
//

import Foundation
import Combine
import UIKit
import GoogleMobileAds


class BaseViewController: UIViewController {
    var subscription: Set<AnyCancellable> = []
    private var interstitial: GADInterstitialAd?
    private var onDismissInterstitial: (()->())? = nil
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    // 필수 생성자로, 슈퍼 클래스에서 정의해둘 경우 서브 클래스가 슈퍼 클래스의 생성자를 상속받지 않는 한 서브클래스에서 반드시 구현해주어야 함
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInterstitialAd()
        
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

extension BaseViewController: GADFullScreenContentDelegate {
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        Defaults.interstitialCount += 1
        self.loadInterstitialAd()
        self.onDismissInterstitial?()
    }
    
    private func loadInterstitialAd() {
        let request = GADRequest()
        GADInterstitialAd.load(
            withAdUnitID: AppConfiguration().GADInterstitialID,
            request: request,
            completionHandler: { [weak self] ad, error in
                guard let self = self else { return }
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                print("[전면광고] AD 설정")
                interstitial = ad
                interstitial?.fullScreenContentDelegate = self
            })
    }
    
    func presentInterstitialAd(onDismiss: @escaping ()->()) {
        self.onDismissInterstitial = onDismiss
        print("[전면광고] \(Defaults.interstitialCount)")
        if let interstitial = interstitial {
            if (Defaults.interstitialCount % (C.INTERSTITIAL_AD_LIMIT)) == (C.INTERSTITIAL_AD_LIMIT - 1) {
                interstitial.present(fromRootViewController: self)
            } else {
                Defaults.interstitialCount += 1
                self.onDismissInterstitial?()
            }
        } else {
            print("Ad wasn't ready")
            self.loadInterstitialAd()
            self.onDismissInterstitial?()
        }
    }
}
