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
                        .frame(width: 20,height: 20)
                        .padding(.trailing,10)
                    VStack {
                        HStack {
                            Text(self.headline ?? "headline")
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        HStack {
                            Text(self.advertiser ?? "advertiser")
                                .font(.system(size: 10))
                                .foregroundColor(.blue)
                            Spacer()
                        }
                    }
                }
            }
            HStack {
                Text(self.body ?? "")
                    .font(.system(size:12))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            if let images = self.images {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(0..<images.count, id:\.self) { i in
                            Image(uiImage: images[i].image!)
                                .resizable()
                                .scaledToFit()
                        }
                        if let media = self.mediaContent {
                            if let image = media.mainImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                    }
                }
            }
           
            HStack {
                StarView(numberOfStar: starRating ?? 0.0, forgroundColor: .yellow)
                Spacer()
            }
            HStack {
                Spacer()
                if let price = self.price {
                    Text(price)
                }
                Button {
                    
                    
                } label : {
                    if let store = self.store {
                        Text(store)
                    }
                    if let action = self.callToAction {
                        Text(action)
                    }
                }
            }


        }
        .frame(height: size.height)
        
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
                VStack {
                    HStack {
                        Spacer()
                        Text("Ad Loading...")
                        Spacer()
                    }
                    RandomSFImageView()
                        .padding(.top,10)
                        .frame(height:80)
                        .foregroundColor(.secondary)
                }
                .frame(height: size.height * CGFloat(numberOfAds))
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.secondary, lineWidth: 6)
                        .opacity(0.5)
                }
                .padding(20)
                
            } else {
                ForEach(0..<(adLoader?.ads.count ?? 0), id:\.self) { i in
                    adLoader!.ads[i].makeView(size: .init(width: size.width - 20, height: size.height))
                        .padding(20)
                    
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

