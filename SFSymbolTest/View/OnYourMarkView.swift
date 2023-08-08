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
    @Binding var isShowLeaderBoard:Bool
    let option:OptionView.Data
    let leaderBoardId:String
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
                     
            HStack {
                RoundedButtonView(text: Text("leaderboard"), style: .normalStyle) {
                    isShowLeaderBoard = true
                }
                
                RoundedButtonView(text: Text("Start!"), style: .normalStyle) {
                    ad.showAd { sucess, time in
                        onTouchupStartBtn()
                    }
                }
            }
            if !Consts.isNotShowAd {
                NativeAdView()
            }
            
        }
        .onAppear {
            isShowGameCenterSigninBtn = GKLocalPlayer.local.isAuthenticated == false
        }
    }
}

