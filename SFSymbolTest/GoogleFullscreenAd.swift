//
//  GoogleADViewController.swift
//  firebaseTest
//
//  Created by Changyul Seo on 2020/03/13.
//  Copyright © 2020 Changyul Seo. All rights reserved.
//

import UIKit
import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

struct GoogleAd {
    static func requestTrackingAuthorization(complete:@escaping()->Void) {
        ATTrackingManager.requestTrackingAuthorization { status in
            print("google ad tracking status : \(status)")
            complete()
        }
    }
}

class GoogleFullScreenAd: NSObject {
    
    var interstitial:GADInterstitialAd? = nil
    
    private func loadAd(complete:@escaping(_ isSucess:Bool)->Void) {
        let request = GADRequest()
        GoogleAd.requestTrackingAuthorization {
            GADInterstitialAd.load(withAdUnitID: Consts.admob_fullscreenAd, request: request) { [weak self] ad, error in
                if let err = error {
                    print("google ad load error : \(err.localizedDescription)")
                }
                ad?.fullScreenContentDelegate = self
                self?.interstitial = ad
                complete(ad != nil)
            }
        }
    }
    
    var callback:(_ isSucess:Bool, _ time:TimeInterval?)->Void = { _,_ in}
    
    func showAd(complete:@escaping(_ isSucess:Bool, _ time:TimeInterval?)->Void) {
        let now = Date()
        if let lastTime = UserDefaults.standard.lastAdWatchTime {
            let interval = now.timeIntervalSince1970 - lastTime.timeIntervalSince1970
            if interval < 60 {
                complete(false,interval)
                return
            }
        }
        callback = complete
        loadAd { [weak self] isSucess in
            if isSucess == false {
                DispatchQueue.main.async {
                    complete(true,nil)
                }
                return
            }
            UserDefaults.standard.lastAdWatchTime = Date()
                        
            if let vc = UIApplication.shared.lastViewController {
                self?.interstitial?.present(fromRootViewController: vc)
            }
        }
    }
}
extension GoogleFullScreenAd: GADFullScreenContentDelegate {
    //광고 실패
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("google ad \(#function)")
        print(error.localizedDescription)
        DispatchQueue.main.async {
            self.callback(true, nil)
        }
    }
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        print("google ad \(#function)")
    }
    //광고시작
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        print("google ad \(#function)")
    }
    //광고 종료
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("google ad \(#function)")
        DispatchQueue.main.async {
            self.callback(true, nil)
        }
    }
}

struct GoogleAdBannerView: UIViewRepresentable {
    let bannerView:GADBannerView
    func makeUIView(context: Context) -> GADBannerView {
        bannerView.adUnitID = Consts.admob_bannerAdId
        bannerView.rootViewController = UIApplication.shared.rootViewController
        return bannerView
    }
  
    func updateUIView(_ uiView: GADBannerView, context: Context) {
        uiView.load(GADRequest())
    }
}
