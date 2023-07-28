//
//  UIApplication+Extensions.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/15.
//

import SwiftUI

extension UIApplication {
    var rootViewController:UIViewController? {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene?.windows.last?.rootViewController        
    }
    
    var lastViewController:UIViewController? {
        var vc:UIViewController? = rootViewController
        while vc?.presentedViewController != nil {
            vc = vc?.presentedViewController
        }
        return vc
    }
}
