//
//  SFSymbolTestApp.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/12.
//

import SwiftUI
import GoogleMobileAds
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      GADMobileAds.sharedInstance().start(completionHandler:{ status in
          print(status)
      })      
      return true
  }
    
}


@main
struct SFSymbolTestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
