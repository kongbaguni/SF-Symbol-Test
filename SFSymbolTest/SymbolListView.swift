//
//  SymbolListView.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/13.
//

import SwiftUI

struct SymbolListView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @State var optionData:OptionView.Data = .init()
    @State var keyword:String = ""
    @State var isPushView:Bool = false
    
    func isInKeyword(imgName:String)->Bool? {
        let kwd = keyword.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if kwd.isEmpty {
            return nil
        }
        return imgName.contains(kwd)
    }
    
    func getImageView(imgName:String)-> some View {
        NavigationLink  {
            SFSymbolDetailView(imageName: imgName, optionData: $optionData)
        } label: {
            HStack {
                Image(systemName: imgName)
                    .imageScale(.large)
                    .padding(.leading,5)
                    .padding(.trailing,5)
                    .padding(.bottom,10)
                    .symbolRenderingMode(optionData.renderingMode)
                    .symbolVariant(optionData.variants)
                    .font(.system(size: 20, weight: optionData.fontWeight))
                    .foregroundStyle(optionData.forgroundColor.0,optionData.forgroundColor.1,optionData.forgroundColor.2)
                
                Text(imgName)
                    .font(.system(size: 12))
                    .padding(5)
                Spacer()
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(symbolKeys, id:\.self) { key in
                Section {
                    if let names = symbolNames[key] {
                        ForEach(0..<names.count, id:\.self) { j in
                            if isInKeyword(imgName: names[j]) != false  {
                                getImageView(imgName: names[j])
                                    .padding(5)
                            }
                        }
                    }
                } header : {
                    Text(key)
                }
            }
        }
        .searchable(text: $keyword)
        .toolbar {
            NavigationLink {
                List {
                    OptionView(data: $optionData, previewNames: ["carbon.dioxide.cloud",
                                                                 "carbon.dioxide.cloud.fill",
                                                                 "bolt.trianglebadge.exclamationmark"])
                    
                }.navigationTitle(Text("Option"))
            } label: {
                Image(systemName:"line.3.horizontal")
            }
            
        }
    }
}

struct SymbolListView_Previews: PreviewProvider {
    static var previews: some View {
        SymbolListView()
    }
}
