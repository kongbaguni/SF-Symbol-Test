//
//  SFSymbolDetailView.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/14.
//

import SwiftUI

struct SFSymbolDetailView: View {
    let imageName:String
    @Binding var optionData:OptionView.Data
    
    var body: some View {
        ScrollView {
            OptionView(data: $optionData, previewNames: [imageName])
        }
        .navigationTitle(imageName)
    }
}

