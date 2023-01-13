//
//  SFSymbolDetailView.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/14.
//

import SwiftUI

struct SFSymbolDetailView: View {
    enum ActionSheetType {
        case selectShareImageSize
        case selectBackgroundColor
    }
    let imageName:String
    @Binding var optionData:OptionView.Data
    @State var isToast = false
    @State var toastMessage = ""
    @State var toastTitle:Text? = nil
    @State var isShowActionSheet = false
    @State var actionSheetType:ActionSheetType? = nil
    @State var bgColor:Color = .white
    let ad = GoogleFullScreenAd()
    var body: some View {
        List {
            OptionView(data: $optionData, previewNames: [imageName])
            
            Section {
                Button {
                    ad.showAd { sucess, time in
                        isShowActionSheet = true
                        actionSheetType = .selectBackgroundColor
                    }
                    
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("share image")
                    }
                }
                .actionSheet(isPresented: $isShowActionSheet) {
                    switch actionSheetType{
                        case .selectBackgroundColor:
                            return .init(title: Text("select background Color"), buttons: [
                                .default(Text("black"),action: {
                                    selectBgColor(color: .black)
                                }),
                                .default(Text("white"),action: {
                                    selectBgColor(color: .white)
                                }),
                                .default(Text("yellow"),action: {
                                    selectBgColor(color: .yellow)
                                }),
                                .default(Text("orange"),action: {
                                    selectBgColor(color: .orange)
                                }),
                                .default(Text("green"),action: {
                                    selectBgColor(color: .green)
                                }),
                                .default(Text("mint"),action: {
                                    selectBgColor(color: .mint)
                                }),
                                .default(Text("gray"),action: {
                                    selectBgColor(color: .gray)
                                }),
                                .cancel()
                            ])
                        case .selectShareImageSize:
                                return .init(title: Text("select share image Size"),
                                      buttons: [
                                        .default(Text("share_small_title"),action: {
                                            shareImage(sizes: [200])
                                        }),
                                        .default(Text("share_medeum_title"), action: {
                                            shareImage(sizes: [400])
                                        }),
                                        .default(Text("share_large_title"), action: {
                                            shareImage(sizes: [600])
                                        }),
                                        .default(Text("share_all_title"), action: {
                                            shareImage(sizes: [200,400,600])
                                        }),

                                        .cancel()
                                ])
                        
                        default:
                            return .init(title: Text("error"))
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
        .navigationTitle(imageName)
        .toast(title: toastTitle, message: toastMessage, isShowing: $isToast, duration: 4)
    }
    private func selectBgColor(color:Color) {
        bgColor = color
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            isShowActionSheet = true
            actionSheetType = .selectShareImageSize
        }
    }
    
    private func shareImage(sizes:[CGFloat]) {
        var result:[Any] = []
        for size in sizes {
            let image = Image(systemName: imageName)
                .symbolRenderingMode(optionData.renderingMode)
                .foregroundStyle(optionData.forgroundColor.0,optionData.forgroundColor.1,optionData.forgroundColor.2)
                .font(.system(size: size * 0.8 ,weight: optionData.fontWeight))
                .frame(width: size,height: size)
                .background(bgColor)
                .asUIImage()
            result.append(image)
        }
        showShareSheet(with: result)
    }
}

