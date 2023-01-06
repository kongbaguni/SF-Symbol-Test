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
        let viewOption = GADNativeAdViewAdOptions()
        viewOption.preferredAdChoicesPosition = .topRightCorner
        
        self.complete = complete
        loader = .init(adUnitID: "",
                         rootViewController: UIApplication.shared.rootViewController,
                         adTypes: [.native], options: [multipleAdsOptions, viewOption])
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
        ads.append(nativeAd)
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        print("GoogleAdLoader did finish Loading \(adLoader)")
        complete(ads)
    }
    
}



extension GADNativeAd {
     
    var adView : some View {
        VStack {
            HStack {
                Text("Ad")
                    .font(.system(size: 12, weight: .bold))
                    .padding(3)
                    .foregroundColor(.white)
                    .background(.orange)
                    .cornerRadius(3)
                
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
                if images.count == 1 {
                    HStack {
                        Spacer()
                        Image(uiImage: images.first!.image!)
                            .resizable()
                            .scaledToFit()
                    }
                }
                else {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(0..<images.count, id:\.self) { i in
                                Image(uiImage: images[i].image!)
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                    }
                    
                }
            }
            
            HStack {
                Spacer()
                
                if let price = self.price {
                    Text(price)
                }
                
                StarView(numberOfStar: starRating ?? 0.0, forgroundColor: .yellow, size:.init(width: 10, height: 10))
                
                Button {
                    
                } label : {
                    if let store = self.store {
                        Text(store)
                    }
                    if let action = self.callToAction {
                        Text(action)
                    }
                }
                if isCustomMuteThisAdAvailable {
                    Button {
                        
                        
                    } label : {
                        Text("Mute")
                    }
                }
            }
        }
    }
    
    func makeView(size:CGSize)-> some View {
        adView.frame(height: size.height)
        
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

