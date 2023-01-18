//
//  BannerAdView.swift
//  PixelArtMaker (iOS)
//
//  Created by 서창열 on 2022/04/19.
//

import SwiftUI
import GoogleMobileAds


struct BannerAdView: View {
    public enum SizeType {
        /** iPhone and iPod Touch ad size. Typically 320x50.*/
        case GADAdSizeBanner
        /** Taller version of GADAdSizeBanner. Typically 320x100.*/
        case GADAdSizeLargeBanner
        /** Medium Rectangle size for the iPad (especially in a UISplitView's left pane). Typically 300x250.*/
        case GADAdSizeMediumRectangle
        /** Full Banner size for the iPad (especially in a UIPopoverController or in UIModalPresentationFormSheet). Typically 468x60.*/
        case GADAdSizeFullBanner
        /** Leaderboard size for the iPad. Typically 728x90*/
        case GADAdSizeLeaderboard
        /** Skyscraper size for the iPad. Mediation only. AdMob/Google does not offer this size. Typically 120x600*/
        case GADAdSizeSkyscraper
    }
    let sizeType:SizeType
    
    private var bannerSize:CGSize {
        switch sizeType {
        case .GADAdSizeBanner:
            return .init(width: 320, height: 50)
        case .GADAdSizeLargeBanner:
            return .init(width: 320, height: 100)
        case .GADAdSizeMediumRectangle:
            return .init(width: 300, height: 250)
        case .GADAdSizeFullBanner:
            return .init(width: 468, height: 60)
        case .GADAdSizeLeaderboard:
            return .init(width: 728, height: 90)
        case .GADAdSizeSkyscraper:
            return .init(width: 120, height: 600)
        }
    }
    
    @State var bannerView:GADBannerView? = nil
    let gad = GoogleFullScreenAd()
    var body: some View {
        VStack {
            if let view = bannerView {
                ZStack {
                    GoogleAdBannerView(bannerView: view)
                        .frame(width: bannerSize.width, height: bannerSize.height, alignment: .center)
                        .cornerRadius(5)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.blue,lineWidth:4)
                        }
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("Ad")
                                .padding(5)
                                .background(Color.orange)
                                .foregroundColor(Color.white)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.blue,lineWidth:6)
                                }
                                .cornerRadius(10)
                                .padding(.leading,-(bannerSize.width/2) - 5)
                                .shadow(color:.blue.opacity(0.5),radius: 5,x:2.5,y:2.5)
                                
                            Spacer()
                        }.padding(.top,-(bannerSize.height/2) - 5)
                        Spacer()
                    }
                }
            } else {
                Button {
                    initAdView()
                } label: {
                    VStack {
                        HStack {
                            Spacer()
                            Text("Ad Loading...")
                            Spacer()
                        }.padding(.top,10)
                        RandomSFImageView()
                            .padding(.top,5)
                            .padding(.bottom,10)
                            .frame(height:50)
                            .foregroundColor(.secondary)
                    }
                    .frame(width: bannerSize.width, height:bannerSize.height)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.secondary, lineWidth: 6)
                            .opacity(0.5)
                    }
                    UIInterfaceOrientationPortraitUpsideDown                }

            }
        }.onAppear {
            initAdView()
        }
        
    }
    
    private func initAdView() {
        var bView:GADBannerView? {
            switch sizeType {
                case .GADAdSizeBanner:
                    return GADBannerView(adSize : GADAdSizeBanner)
                case .GADAdSizeLargeBanner:
                    return GADBannerView(adSize : GADAdSizeLargeBanner)
                case .GADAdSizeMediumRectangle:
                    return GADBannerView(adSize : GADAdSizeMediumRectangle)
                case .GADAdSizeFullBanner:
                    return GADBannerView(adSize : GADAdSizeFullBanner)
                case .GADAdSizeLeaderboard:
                    return GADBannerView(adSize : GADAdSizeLeaderboard)
                case .GADAdSizeSkyscraper:
                    return GADBannerView(adSize : GADAdSizeSkyscraper)
            }
        }

        guard bannerView == nil else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            GoogleAd.requestTrackingAuthorization {
                DispatchQueue.main.async {
                    bannerView = bView
                }
            }
        }
    }
}

