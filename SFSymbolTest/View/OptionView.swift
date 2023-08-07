//
//  OptionView.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/14.
//

import SwiftUI

extension Notification.Name {
    static let saveOption = Notification.Name("saveOption_observer")
    
}
struct OptionView: View {
    struct Data {
        var renderingModeSelect:Int {
            didSet {
                UserDefaults.standard.set(renderingModeSelect, forKey: "renderingModeSelect")
            }
        }
        
        var fontWeightSelect:Int {
            didSet {
                UserDefaults.standard.set(fontWeightSelect, forKey: "fontWeightSelect")
            }
        }
        var forgroundColorSelect1:Int {
            didSet {
                UserDefaults.standard.set(forgroundColorSelect1, forKey: "forgroundColorSelect1")
            }
        }
        
        var forgroundColorSelect2:Int {
            didSet {
                UserDefaults.standard.set(forgroundColorSelect2, forKey: "forgroundColorSelect2")
            }
        }
        
        var forgroundColorSelect3:Int {
            didSet {
                UserDefaults.standard.set(forgroundColorSelect3, forKey: "forgroundColorSelect3")
            }
        }

        init() {
            renderingModeSelect = UserDefaults.standard.integer(forKey: "renderingModeSelect")
            fontWeightSelect = UserDefaults.standard.integer(forKey: "fontWeightSelect")
            forgroundColorSelect1 = UserDefaults.standard.integer(forKey: "forgroundColorSelect1")
            forgroundColorSelect2 =  UserDefaults.standard.integer(forKey: "forgroundColorSelect2")
            forgroundColorSelect3 = UserDefaults.standard.integer(forKey: "forgroundColorSelect3")
        }
        
        
        var renderingMode:SymbolRenderingMode {
            Option.symbolRenderingModes[renderingModeSelect].1
        }
        
        
        var fontWeight:Font.Weight {
            Option.fontWeights[fontWeightSelect].1
        }
        
        var forgroundColor:(Color,Color,Color) {
            (
                Option.colorList[forgroundColorSelect1].1,
                Option.colorList[forgroundColorSelect2].1,
                Option.colorList[forgroundColorSelect3].1
            )
        }
        
        mutating func load() {
            let option = UserDefaults.standard.loadOption()
            renderingModeSelect = option.renderingModeSelect
            fontWeightSelect = option.fontWeightSelect
            forgroundColorSelect1 = option.forgroundColorSelect1
            forgroundColorSelect2 = option.forgroundColorSelect2
            forgroundColorSelect3 = option.forgroundColorSelect3
            
//            renderingModeSelect = UserDefaults.standard.integer(forKey: "renderingModeSelect")
//            fontWeightSelect = UserDefaults.standard.integer(forKey: "fontWeightSelect")
//            forgroundColorSelect1 = UserDefaults.standard.integer(forKey: "forgroundColorSelect1")
//            forgroundColorSelect2 =  UserDefaults.standard.integer(forKey: "forgroundColorSelect2")
//            forgroundColorSelect3 = UserDefaults.standard.integer(forKey: "forgroundColorSelect3")
        }
                
    }
    
    var isPallete : Bool {
        switch Option.symbolRenderingModes[data.renderingModeSelect].0 {
            case "palette":
                return true
            default:
                return false
        }
    }
    
    @Binding var data:Data
    
    let previewNames:[String]

    var body: some View {
        Group {
            Section {
                LazyVGrid(columns: GridItem.makeGridItems(number: previewNames.count)) {
                    ForEach(previewNames, id:\.self) { previewName in
                        VStack {
                            Image(systemName: previewName)
                                .font(.system(size: 150 / CGFloat(previewNames.count), weight: data.fontWeight))
                                .symbolRenderingMode(data.renderingMode)                                
                                .foregroundStyle(data.forgroundColor.0, data.forgroundColor.1, data.forgroundColor.2)
                            if previewNames.count == 1 {
                                Text(previewName)
                            }
                        }
                    }
                }
            }
            Section {
                Picker(selection: $data.renderingModeSelect) {
                    ForEach(0..<Option.symbolRenderingModes.count, id:\.self) { i in
                        Text(Option.symbolRenderingModes[i].0)
                    }
                } label: {
                    Text("renderingMode")
                }
                                
                Picker(selection: $data.fontWeightSelect) {
                    ForEach(0..<Option.fontWeights.count, id:\.self) { i in
                        Text(Option.fontWeights[i].0)
                    }
                } label: {
                    Text("fontWeight")
                        .fontWeight(data.fontWeight)
                }
                
                Picker(selection: $data.forgroundColorSelect1) {
                    ForEach(0..<Option.colorList.count, id:\.self) { i in
                        Text(Option.colorList[i].0)
                    }
                } label: {
                    Text(isPallete ? "forground Color 1" : "forground Color")
                }
                .foregroundColor(data.forgroundColor.0)
                
                
                if isPallete {
                    Picker(selection: $data.forgroundColorSelect2) {
                        ForEach(0..<Option.colorList.count, id:\.self) { i in
                            Text(Option.colorList[i].0)
                        }
                    } label: {
                        Text("forground Color 2")
                    }
                    .foregroundColor(data.forgroundColor.1)
                    
                    
                    Picker(selection: $data.forgroundColorSelect3) {
                        ForEach(0..<Option.colorList.count, id:\.self) { i in
                            Text(Option.colorList[i].0)
                        }
                    } label: {
                        Text("forground Color 3")
                    }
                    .foregroundColor(data.forgroundColor.2)
                }
            }
            Section {
                NativeAdView()
            }
        }
        .onDisappear {
            let option:Option = .init(
                renderingModeSelect: data.renderingModeSelect,
                fontWeightSelect: data.fontWeightSelect,
                forgroundColorSelect1: data.forgroundColorSelect1,
                forgroundColorSelect2: data.forgroundColorSelect2,
                forgroundColorSelect3: data.forgroundColorSelect3)
            UserDefaults.standard.saveOption(data: option)
            NotificationCenter.default.post(name: .saveOption, object: option)
        }
    }
}

