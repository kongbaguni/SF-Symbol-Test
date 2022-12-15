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
    ("primary",.primary),
    ("secondary",.secondary),
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
    ("purple",.purple),
    ("red",.red),
    ("teal",.teal),
    ("yellow",.yellow),
]

struct OptionView: View {
    struct Data {
        var renderingModeSelect:Int
        var variantSelect:Int
        var fontWeightSelect:Int
        var forgroundColorSelect1:Int
        var forgroundColorSelect2:Int
        var forgroundColorSelect3:Int

        init() {
            renderingModeSelect = UserDefaults.standard.integer(forKey: "renderingModeSelect")
            variantSelect = UserDefaults.standard.integer(forKey: "variantSelect")
            fontWeightSelect = UserDefaults.standard.integer(forKey: "fontWeightSelect")
            forgroundColorSelect1 = UserDefaults.standard.integer(forKey: "forgroundColorSelect1")
            forgroundColorSelect2 =  UserDefaults.standard.integer(forKey: "forgroundColorSelect2")
            forgroundColorSelect3 = UserDefaults.standard.integer(forKey: "forgroundColorSelect3")
            
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
        
        var forgroundColor:(Color,Color,Color) {
            (
                colorList[forgroundColorSelect1].1,
                colorList[forgroundColorSelect2].1,
                colorList[forgroundColorSelect3].1
            )
        }
        
        func save() {
            UserDefaults.standard.set(renderingModeSelect, forKey: "renderingModeSelect")
            UserDefaults.standard.set(variantSelect, forKey: "variantSelect")
            UserDefaults.standard.set(fontWeightSelect, forKey: "fontWeightSelect")
            UserDefaults.standard.set(forgroundColorSelect1, forKey: "forgroundColorSelect1")
            UserDefaults.standard.set(forgroundColorSelect2, forKey: "forgroundColorSelect2")
            UserDefaults.standard.set(forgroundColorSelect3, forKey: "forgroundColorSelect3")
        }
        
    }
    
    var isPallete : Bool {
        switch symbolRenderingModes[data.renderingModeSelect].0 {
            case "palette":
                return true
            default:
                return false
        }
    }
    
    @Binding var data:Data
    let previewNames:[String]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: GridItem.makeGridItems(number: previewNames.count)) {
                ForEach(previewNames, id:\.self) { previewName in
                    Image(systemName: previewName)
                        .font(.system(size: 200 / CGFloat(previewNames.count)))
                        .symbolRenderingMode(data.renderingMode)
                        .symbolVariant(data.variants)
                        .foregroundStyle(data.forgroundColor.0, data.forgroundColor.1, data.forgroundColor.2)
                        .fontWeight(data.fontWeight)
                }
            }
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
                Text(isPallete ? "forground Color1" : "forground Color")
                    .foregroundColor(data.forgroundColor.0)
                Picker(selection: $data.forgroundColorSelect1) {
                    ForEach(0..<colorList.count, id:\.self) { i in
                        Text(colorList[i].0)
                    }
                } label: {
                    Text("forground Color Select")
                }
                Spacer()
            }.padding(.leading,20)
            
            if isPallete {
                HStack {
                    Text("forground Color2")
                        .foregroundColor(data.forgroundColor.1)
                    Picker(selection: $data.forgroundColorSelect2) {
                        ForEach(0..<colorList.count, id:\.self) { i in
                            Text(colorList[i].0)
                        }
                    } label: {
                        Text("forground Color Select")
                    }
                    Spacer()
                }.padding(.leading,20)
                
                HStack {
                    Text("forground Color3")
                        .foregroundColor(data.forgroundColor.2)
                    Picker(selection: $data.forgroundColorSelect3) {
                        ForEach(0..<colorList.count, id:\.self) { i in
                            Text(colorList[i].0)
                        }
                    } label: {
                        Text("forground Color Select")
                    }
                    Spacer()
                }.padding(.leading,20)
            }

        }
        .onDisappear {
            data.save()
        }
    }
}

