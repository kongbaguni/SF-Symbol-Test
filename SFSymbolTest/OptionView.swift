//
//  OptionView.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/14.
//

import SwiftUI
fileprivate let symbolRenderingModes:[(String,SymbolRenderingMode)] = [
    ("multicolor",.multicolor),
    ("hierarchical",.hierarchical),
    ("monochrome",.monochrome),
    ("palette",.palette)
]

fileprivate let symbolVariants:[(String,SymbolVariants)] = [
    ("none",.none),
    ("circle",.circle),
    ("fill",.fill),
    ("rectangle",.rectangle),
    ("slash",.slash),
    ("square",.square)
]

fileprivate let fontWeights:[(String,Font.Weight)] = [
    ("ultraLight",.ultraLight),
    ("light",.light),
    ("thin",.thin),
    ("regular",.regular),
    ("medium",.medium),
    ("semibold",.semibold),
    ("bold",.bold),
    ("heavy",.heavy),
    ("black",.black)
]


fileprivate let colorList:[(String,Color)] = [
    ("mint",.mint),
    ("black",.black),
    ("white",.white),
    ("accentColor",.accentColor),
    ("blue",.blue),
    ("brown",.brown),
    ("cyan",.cyan),
    ("gray",.gray),
    ("green",.green),
    ("indigo",.indigo),
    ("orange",.orange),
    ("pink",.pink),
    ("primary",.primary),
    ("purple",.purple),
    ("red",.red),
    ("secondary",.secondary),
    ("teal",.teal),
    ("yellow",.yellow),
]

struct OptionView: View {
    struct Data {
        var renderingModeSelect:Int
        var variantSelect:Int
        var fontWeightSelect:Int
        var forgroundColorSelect:Int
        
        init() {
            renderingModeSelect = 0
            variantSelect = 0
            fontWeightSelect = 0
            forgroundColorSelect = 0
        }
        
        var renderingMode:SymbolRenderingMode {
            symbolRenderingModes[renderingModeSelect].1
        }
        
        var variants:SymbolVariants {
            symbolVariants[variantSelect].1
        }
        
        var fontWeight:Font.Weight {
            fontWeights[fontWeightSelect].1
        }
        
        var forgroundColor:Color {
            colorList[forgroundColorSelect].1
        }
    }
    
    @Binding var data:Data
    

    
    
    var body: some View {
        ScrollView {
            HStack {
                Text("rendering mode")
                Picker(selection: $data.renderingModeSelect) {
                    ForEach(0..<symbolRenderingModes.count, id:\.self) { i in
                        Text(symbolRenderingModes[i].0)
                    }
                } label: {
                    Text("RenderingMode Select")
                }
                Spacer()
            }.padding(.leading,20)
            
            HStack {
                Text("variant")
                Picker(selection: $data.variantSelect) {
                    ForEach(0..<symbolVariants.count, id:\.self) { i in
                        Text(symbolVariants[i].0)
                    }
                } label: {
                    Text("Variant Select")
                }
                Spacer()
            }.padding(.leading,20)
            
            HStack {
                Text("fontWeight")
                    .fontWeight(data.fontWeight)
                Picker(selection: $data.fontWeightSelect) {
                    ForEach(0..<fontWeights.count, id:\.self) { i in
                        Text(fontWeights[i].0)
                    }
                } label: {
                    Text("fontWeights Select")
                }
                Spacer()
            }.padding(.leading,20)
            
            HStack {
                Text("forground Color")
                    .foregroundColor(data.forgroundColor)
                Picker(selection: $data.forgroundColorSelect) {
                    ForEach(0..<colorList.count, id:\.self) { i in
                        Text(colorList[i].0)
                    }
                } label: {
                    Text("forground Color Select")
                }
                Spacer()
            }.padding(.leading,20)
        }
        .navigationTitle(Text("Option"))
    }
}

