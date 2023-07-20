//
//  ContentView.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/12.
//

import SwiftUI
import GoogleMobileAds


struct ContentView: View {
    @State var optionData:OptionView.Data = .init()
    
    
    init() {
        GoogleAdPrompt.promptWithDelay {
            
        }
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
