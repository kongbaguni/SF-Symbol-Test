//
//  SymbolListView.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/13.
//

import SwiftUI

struct SymbolListView: View {
    private func getColumns(isWide:Bool)->[GridItem] {
        isWide
        ? [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        : [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    }
 
    @State var optionData:OptionView.Data = .init()
    
    @State var keyword:String = ""
    @State var isPushView:Bool = false
    func getImageView(imgName:String)-> some View {
        NavigationLink  {
            SFSymbolDetailView(imageName: imgName, optionData: $optionData)
        } label: {
            VStack {
                let kwd = keyword.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                let a = kwd.isEmpty
                let b = imgName.contains(kwd)
                let isBold = !a && b
                Image(systemName: imgName)
                    .imageScale(.large)
                    .padding(.leading,5)
                    .padding(.trailing,5)
                    .padding(.bottom,10)
                    .symbolRenderingMode(optionData.renderingMode)
                    .symbolVariant(optionData.variants)
                    .font(.system(size: 60))
                    .fontWeight(optionData.fontWeight)
                    .foregroundColor(optionData.forgroundColor)
                
                Text(imgName)
                    .font(.system(size: 8, weight: isBold ? .heavy : .regular))
                    .padding(5)
                Spacer()
            }
        }
    }
    
    var body: some View {
        GeometryReader { geomentry in
            ScrollView {

                ForEach(symbolKeys, id:\.self) { key in
                    HStack {
                        Text(key)
                        Spacer()
                    }.padding(20)
                    if let names = symbolNames[key] {
                        LazyVGrid(columns: getColumns(isWide: geomentry.size.width > geomentry.size.height)) {
                            ForEach(0..<names.count, id:\.self) { j in
                                getImageView(imgName: names[j])
                                    .padding(5)
                            }
                        }
                    }
                }
            }
            .searchable(text: $keyword)
        }
        .toolbar {
            NavigationLink {
                OptionView(data: $optionData)
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
