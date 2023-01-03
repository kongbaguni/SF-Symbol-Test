//
//  ContentView.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/12.
//

import SwiftUI

struct ContentView: View {    
    var body: some View {
        NavigationView {
            SymbolListView(category: nil,title: nil)
                .navigationTitle("SF Symbols")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
