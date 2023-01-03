//
//  AdView.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2023/01/02.
//

import SwiftUI
import GoogleMobileAds
class GoogleAdLoader : NSObject {
    let loader:GADAdLoader
    let complete:(_ ads:[GADNativeAd])->Void
    var ads:[GADNativeAd] = []
    init(numberOfAds:Int,complete:@escaping(_ ads:[GADNativeAd])->Void) {
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
            multipleAdsOptions.numberOfAds = numberOfAds
        self.complete = complete
        loader = .init(adUnitID: Consts.admob_nativeAdId,
                         rootViewController: UIApplication.shared.rootViewController,
                         adTypes: [.native], options: [multipleAdsOptions])
        super.init()
        loader.delegate = self
        loader.load(GADRequest())
    }
}

extension GoogleAdLoader : GADNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("GoogleAdLoader did Fail \(error.localizedDescription)")
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        print("GoogleAdLoader did Recive Ad : \(nativeAd)")
        nativeAd.delegate = self
        ads.append(nativeAd)
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        print("GoogleAdLoader did finish Loading \(adLoader)")
        complete(ads)
    }
    
}

extension GoogleAdLoader : GADNativeAdDelegate {
    func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
      // The native ad was shown.
    }

    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
      // The native ad was clicked on.
    }

    func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
      // The native ad will present a full screen view.
    }

    func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
      // The native ad will dismiss a full screen view.
    }

    func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
      // The native ad did dismiss a full screen view.
    }

    func nativeAdWillLeaveApplication(_ nativeAd: GADNativeAd) {
      // The native ad will cause the application to become inactive and
      // open a new application.
    }
}

extension GADNativeAd {
     
    func makeView(size:CGSize)-> some View {
        VStack {
            HStack {
                if let image = self.icon?.image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 15,height: 15)
                    
                    if let headline = self.headline {
                        Text(headline)
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
            }
            if let images = self.images {
                ForEach(0..<images.count, id:\.self) { i in
                    Button {
                        print(self.callToAction ?? "액션 없네")
                    } label: {
                        Image(uiImage: images[i].image!)
                            .resizable()
                            .frame(width:size.width, height: size.height)
                            .cornerRadius(10)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.secondary,lineWidth: 3)
                            }
                    }
                    
                }
            }

            if let body = self.body {
                HStack {
                    Text(body)
                        .font(.system(size:12))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
            if let rating = self.starRating {
                HStack {
                    StarView(numberOfStar: rating, forgroundColor: .yellow)
                    Spacer()
                }
            }


        }.frame(width:size.width)
        
    }
}

struct AdView: View {
    @State var isLoading = true
    @State var adLoader:GoogleAdLoader? = nil
    let size:CGSize
    let numberOfAds:Int
    var body: some View {
        VStack {
            if isLoading {
                HStack {
                    Spacer()
                    Text("Ad Loading...")
                    Spacer()
                }
            } else {
                ForEach(0..<(adLoader?.ads.count ?? 0), id:\.self) { i in
                    adLoader!.ads[i].makeView(size: .init(width: size.width - 20, height: 100))
                        .padding(10)
                    
                }
            }
        }
        .onAppear {
            if adLoader?.ads.count == 0 || adLoader == nil {
                adLoader = GoogleAdLoader(numberOfAds: numberOfAds) { ads in
                    print("_-------------------_")
                    print(ads)
                    isLoading = false
                }
            }
        }
    }

}

