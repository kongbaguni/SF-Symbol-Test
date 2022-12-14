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
            Image(systemName: imageName)
                .imageScale(.large)
                .font(.system(size: 150))
                .foregroundColor(optionData.forgroundColor)
                .fontWeight(optionData.fontWeight)
                .symbolRenderingMode(optionData.renderingMode)
                .symbolVariant(optionData.variants)
                .frame(width:300,height: 300)
            
            OptionView(data: $optionData)
        }
        .navigationTitle(imageName)
    }
}

