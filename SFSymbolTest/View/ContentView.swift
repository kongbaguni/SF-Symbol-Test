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
    @State var optionData:OptionView.Data = .init()
    
    
    init() {
        #if DEBUG
        UMPConsentInformation.sharedInstance.reset()
        #endif

        GoogleAd.requestTrackingAuthorization {
            
        }
        ump()
    }
    
    func ump() {
        func loadForm() {
          // Loads a consent form. Must be called on the main thread.
            UMPConsentForm.load { form, loadError in
                if loadError != nil {
                  // Handle the error
                } else {
                    // Present the form. You can also hold on to the reference to present
                    // later.
                    if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.required {
                        form?.present(
                            from: UIApplication.shared.lastViewController!,
                            completionHandler: { dismissError in
                                if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.obtained {
                                    // App can start requesting ads.
                                }
                                // Handle dismissal by reloading form.
                                loadForm();
                            })
                    } else {
                        // Keep the form available for changes to user consent.
                    }
                    
                }

            }
        }
        // Create a UMPRequestParameters object.
        let parameters = UMPRequestParameters()
        // Set tag for under age of consent. Here false means users are not under age.
        parameters.tagForUnderAgeOfConsent = false
        #if DEBUG
        let debugSettings = UMPDebugSettings()
//        debugSettings.testDeviceIdentifiers = ["78ce88aff302a5f4dfa5226a766c0b5a"]
        debugSettings.geography = UMPDebugGeography.EEA
        parameters.debugSettings = debugSettings
        #endif
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(
            with: parameters,
            completionHandler: { error in
                if error != nil {
                    // Handle the error.
                    print(error!.localizedDescription)
                } else {
                    let formStatus = UMPConsentInformation.sharedInstance.formStatus
                    if formStatus == UMPFormStatus.available {
                      loadForm()
                    }

                }
            })
    }
    
    var body: some View {
        NavigationView {
            NavigationStack {
                SymbolListView(category: nil,title: nil, isFavorite : false)                    
            }
            .navigationTitle("SF Symbols")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink {
                        List {
                            OptionView(data: $optionData, previewNames: ["mic",
                                                                         "carbon.dioxide.cloud",
                                                                         "carbon.dioxide.cloud.fill",
                                                                         "bolt.trianglebadge.exclamationmark"])
                            
                        }.navigationTitle(Text("Option"))
                    } label: {
                        Image(systemName:"gear")
                    }
                }
            }
        }.navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
