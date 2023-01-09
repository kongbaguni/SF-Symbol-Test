//
//  OnYourMarkView.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/22.
//

import SwiftUI
import GameKit

struct OnYourMarkView: View {
    @State var isShowGameCenterSigninBtn = false
    let option:OptionView.Data
    let onTouchupStartBtn:()->Void
    let ad = GoogleFullScreenAd()
    var body: some View {

        VStack {
            Text("Readay")
                .font(.system(size: 20, weight: .heavy))
                .foregroundColor(Color.mint)
                .padding(20)
            
            Image(systemName: "flag.checkered")
                .symbolRenderingMode(option.renderingMode)
                .foregroundStyle(option.forgroundColor.0,option.forgroundColor.1,option.forgroundColor.2)
                .font(.system(size: 100,weight: option.fontWeight))
            
            //            if isShowGameCenterSigninBtn {
            //                RoundedButtonView(text: Text("gameCenter"), style: .normalStyle) {
            //                    GameManager.shared.authuser {
            //                        isShowGameCenterSigninBtn = GKLocalPlayer.local.isAuthenticated == false
            //                    }
            //                }
            //            }
            
            
            RoundedButtonView(text: Text("Start!"), style: .normalStyle) {
                ad.showAd { sucess, time in
                    onTouchupStartBtn()
                }
            }
            if !Consts.isNotShowAd {
                BannerAdView(sizeType: .GADAdSizeMediumRectangle)
                    .padding(.top,50)
            }
            
        }
        .onAppear {
            isShowGameCenterSigninBtn = GKLocalPlayer.local.isAuthenticated == false
        }
    }
}

