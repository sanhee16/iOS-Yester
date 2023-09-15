//
//  BannerADViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/09/14.
//

import Foundation
import GoogleMobileAds
import UIKit
import PinLayout
import FlexLayout

class BannerADViewController: UIViewController {
    var bannerView: GADBannerView!
    fileprivate lazy var rootFlexContainer: UIView = UIView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bannerView = GADBannerView(adSize: GADAdSizeBanner)
        self.bannerView.delegate = self
        self.bannerView.adUnitID = AppConfiguration().GADBannerID
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
        
        self.setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
    }
    
    private func setLayout() {
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex
            .justifyContent(.center)
            .alignItems(.center)
            .size(GADAdSizeBanner.size)
            .define { flex in
                if let bannerView = bannerView {
                    flex.addItem(bannerView)
                        .width(100%)
                        .height(100%)
                }
            }
    }
}

extension BannerADViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDIsmissScreen")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
}
