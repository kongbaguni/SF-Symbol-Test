//
//  Consts.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2023/01/02.
//

import Foundation

struct Consts {
    static let isNotShowAd = false
#if DEBUG || TEST
    static let admob_bannerAdId = "ca-app-pub-3940256099942544/2934735716"
    static let admob_fullscreenAd = "ca-app-pub-3940256099942544/4411468910"
#else
    static let admob_bannerAdId = "ca-app-pub-7714069006629518/6357047878"
    static let admob_fullscreenAd = "ca-app-pub-7714069006629518/5471944252"
#endif
}
