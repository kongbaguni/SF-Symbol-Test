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
            VStack {
                Image(systemName: imgName)
                    .imageScale(.large)
                    .padding(.leading,5)
                    .padding(.trailing,5)
                    .padding(.bottom,10)
                    .symbolRenderingMode(optionData.renderingMode)
                    .symbolVariant(optionData.variants)
                    .font(.system(size: 60))
                    .fontWeight(optionData.fontWeight)
                    .foregroundStyle(optionData.forgroundColor.0,optionData.forgroundColor.1,optionData.forgroundColor.2)
                
                Text(imgName)
                    .font(.system(size: 12))
                    .padding(5)
                Spacer()
            }
        }
    }
    
    var body: some View {
        ScrollView {
            ForEach(symbolKeys, id:\.self) { key in
                HStack {
                    Text(key)
                    Spacer()
                }.padding(20)
                if let names = symbolNames[key] {
                    LazyVGrid(columns: columns) {
                        ForEach(0..<names.count, id:\.self) { j in
                            if isInKeyword(imgName: names[j]) != false  {
                                getImageView(imgName: names[j])
                                    .padding(5)
                            }
                        }
                    }
                }
            }
        }
        .searchable(text: $keyword)
        .toolbar {
            NavigationLink {
                OptionView(data: $optionData, previewNames: ["carbon.dioxide.cloud",
                                                             "carbon.dioxide.cloud.fill",
                                                             "bolt.trianglebadge.exclamationmark"])
                    .navigationTitle(Text("Option"))
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
