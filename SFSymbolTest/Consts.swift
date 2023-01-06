//
//  Consts.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2023/01/02.
//

import Foundation

struct Consts {
    #if DEBUG || TEST
    static let admob_nativeAdId = "ca-app-pub-3940256099942544/3986624511"
    static let admob_bannerAdId = "ca-app-pub-3940256099942544/2934735716"
    static let admob_rewordAdId = "ca-app-pub-3940256099942544/6978759866" // test ga id
    #else
    static let admob_nativeAdId = "ca-app-pub-7714069006629518/6987958485"
    static let admob_bannerAdId = "ca-app-pub-7714069006629518/6357047878"
    static let admob_rewordAdId = "ca-app-pub-7714069006629518/8047751100" // real ga id
    #endif
    
    
}
