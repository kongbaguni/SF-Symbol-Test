//
//  AdView.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2023/01/02.
//

import SwiftUI
import GoogleMobileAds


#if DEBUG
fileprivate let adId = "ca-app-pub-3940256099942544/3986624511"
#else
fileprivate let adId = "ca-app-pub-7714069006629518/8337557651"
#endif


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
        loader = .init(adUnitID: adId,
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
        HStack {
            VStack (alignment: .leading) {
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
                        VStack(alignment: .leading) {
                            if let headline = headline {
                                Text(headline)
                                    .font(.system(size: 10))
                                    .foregroundColor(.secondary)
                                    .lineLimit(3)
                            }
                            if let advertiser = advertiser {
                                Text(advertiser)
                                    .font(.system(size: 10))
                                    .foregroundColor(.blue)
                                    .lineLimit(10)
                            }
                        }
                    }
                    Spacer()
                }
                Text(self.body ?? "")
                    .lineLimit(10)
                    .font(.system(size:12))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                
                
                HStack {
                    Spacer()
                    
                    if let price = self.price {
                        Text(price)
                            .font(.system(size: 10))
                    }
                    
                    if let star = starRating {
                        StarView(numberOfStar: star, forgroundColor: .yellow, size:.init(width: 10, height: 10))
                    }
                }
            }
            if let img = images?.first?.image {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .cornerRadius(5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.blue,lineWidth:4)
                    }
                    .padding(.leading, 5)
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

