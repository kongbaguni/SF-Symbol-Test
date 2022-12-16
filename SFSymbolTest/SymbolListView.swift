//
//  SymbolListView.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/13.
//

import SwiftUI

struct SymbolListView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @State var names:[String] = []
    
    @State var optionData:OptionView.Data = .init()
    @State var keyword:String = ""
    @State var isPushView:Bool = false
    
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
            .padding(5)
            .padding(.leading,10)
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if category == nil && filteredArray == nil {
                    ForEach(0..<SFSymbolCategorys.count, id:\.self) { i in
                        let category = SFSymbolCategorys[i]
                        getImageView(destination: SymbolListView(category: category.0, title: category.2).navigationTitle(category.2),
                                     imgName: category.1, text: category.2)
                    }
                } else {
                    ForEach(filteredArray != nil ? filteredArray! : names, id:\.self) { name in
                        getImageView(destination: SFSymbolDetailView(imageName: name, optionData: $optionData),
                                     imgName: name)
                    }
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

