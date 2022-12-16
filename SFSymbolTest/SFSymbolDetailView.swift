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
    @State var isToast = false
    @State var toastMessage = ""
    @State var toastTitle:Text? = nil
    
    var body: some View {
        List {
            OptionView(data: $optionData, previewNames: [imageName])
            
            Section {
                Button {
                    let image = Image(systemName: imageName)
                        .symbolRenderingMode(optionData.renderingMode)
                        .foregroundStyle(optionData.forgroundColor.0,optionData.forgroundColor.1,optionData.forgroundColor.2)
                        .font(.system(size: 200,weight: optionData.fontWeight))
                        .frame(width: 300,height: 300)
                        .asUIImage()
                    showShareSheet(with: [image])
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("share image")
                    }
                }
                
                Button {
                    UIPasteboard.general.string = imageName
                    toastTitle = Text("SF symbol name copyed")
                    toastMessage = imageName
                    isToast = true
                } label : {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        Text("copy symbol name")
                    }
                }
            }
        }
        .navigationTitle(imageName.components(separatedBy: ".").first!)
        .toast(title: toastTitle, message: toastMessage, isShowing: $isToast, duration: 4)
        
    }
}

