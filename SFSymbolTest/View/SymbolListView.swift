//
//  SymbolListView.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/13.
//

import SwiftUI

struct SymbolListView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    enum ActionSheetMode {
        case 개임선택
    }
    
    @State var names:[String] = []
    
    @State var optionData:OptionView.Data = .init()
    @State var keyword = ""
    
    @State var isPushView = false
    @State var isActionSheet = false
    @State var actionSheetMode:ActionSheetMode? = nil
    @State var pushGame1 = false
    @State var pushGame2 = false
    let category:String?
    let title:Text?
    
    var filteredArray:[String]? {
        let kwd = keyword.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if kwd.isEmpty {
            return nil
        }
        let result = names.filter { name in
            return name.contains(kwd)
        }
        return result
    }
    
    var data:[Any] {
        if let arr = filteredArray {
            return arr
        }
        else if category != nil {
            return names
        }

        return SFSymbolCategorys
    }
    
    func getImageView(destination:some View,imgName:String, text:Text? = nil)-> some View {
        NavigationLink  {
            destination
//
        } label: {
            HStack {
                Image(systemName: imgName)
                    .imageScale(.large)
                    .symbolRenderingMode(optionData.renderingMode)
                    .font(.system(size: 25, weight: optionData.fontWeight))
                    .foregroundStyle(optionData.forgroundColor.0,optionData.forgroundColor.1,optionData.forgroundColor.2)
                
                (text != nil ? text! : Text(imgName))
                    .font(.system(size: 12))
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.secondary,lineWidth: 3)
                    .opacity(0.7)
            }
            .padding(5)
            .padding(.leading,15)
            .padding(.trailing,15)
        }
    }
    var isiPad : Bool {
        return UIDevice.current.model.lowercased().contains("ipad") == true
    }
    
    var list : some View {
        Group {
            ForEach(0..<data.count, id:\.self) { i in
                if i % (isiPad ? 30 : 10) == 0 {
                    if !Consts.isNotShowAd {
                        BannerAdView(sizeType: .GADAdSizeLargeBanner)
                            .padding(.top,10)
                            .padding(.bottom,10)
                    }
                }
                if let category = data[i] as? (String,String,Text) {
                    getImageView(destination: SymbolListView(category: category.0, title: category.2).navigationTitle(category.2),
                                 imgName: category.1, text: category.2)

                }
                if let name = data[i] as? String {
                    getImageView(destination: SFSymbolDetailView(imageName: name, optionData: $optionData),
                                 imgName: name)
                }
            }
        }
    }
    
    var body: some View {
        GeometryReader { geomentry in
            ScrollView {
                RoundedButtonView(text: Text("game"), style: .normalStyle) {
                    isActionSheet = true
                    actionSheetMode = .개임선택
                }
                .padding(20)
                .actionSheet(isPresented: $isActionSheet, content: {
                    switch actionSheetMode {
                        case .개임선택:
                            return ActionSheet(title: Text("Choose Game") ,buttons: [
                                .default(Text("game 1")) {
                                    pushGame1 = true
                                },
                                .default(Text("game 2")) {
                                    pushGame2 = true
                                },
                                .cancel()
                            ])
                        default:
                            return ActionSheet(title: Text(""))
                    }
                    
                })

                NavigationLink(destination: GameView(mode: .그림고르기), isActive: $pushGame1) {
                    
                }
                NavigationLink(destination: GameView(mode: .글자고르기), isActive: $pushGame2) {
                    
                }
                
                if isiPad {
                    LazyVGrid(columns: GridItem.makeGridItems(number: 2)) {
                        list
                    }
                } else {
                    LazyVStack {
                        list
                    }
                }
                if !Consts.isNotShowAd && !isiPad{
                    BannerAdView(sizeType: .GADAdSizeLargeBanner)
                        .padding(.top,10)
                        .padding(.bottom,10)
                }
            }
        }
        .onAppear {
            optionData.load()
            SFSymbol(names: $names).loadData(category: category ?? "all")
        }
        .searchable(text: $keyword)
        .toolbar {
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
}

