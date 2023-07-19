//
//  ContentView.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/12.
//

import SwiftUI
import GoogleMobileAds
import UserMessagingPlatform


struct ContentView: View {
    init() {
        
        // Create a UMPRequestParameters object.
        let parameters = UMPRequestParameters()
        // Set tag for under age of consent. Here false means users are not under age.
        parameters.tagForUnderAgeOfConsent = false
        
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(
            with: parameters,
            completionHandler: { error in
                if error != nil {
                    // Handle the error.
                } else {
                    // The consent information state was updated.
                    // You are now ready to check if a form is
                    // available.
                    GoogleAd.requestTrackingAuthorization {
                    }
                }
            })
        
        
    }
    var body: some View {
        NavigationView {
            NavigationStack {
                SymbolListView(category: nil,title: nil)
                    .navigationTitle("SF Symbols")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
