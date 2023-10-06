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
    let data:Data = .init()
    @AppStorage("renderingModeSelect") var renderingModeSelect:Int = 0
    @AppStorage("fontWeightSelect") var fontWeightSelect:Int = 0
    @AppStorage("forgroundColorSelect1") var forgroundColorSelect1:Int = 0
    @AppStorage("forgroundColorSelect2") var forgroundColorSelect2:Int = 0
    @AppStorage("forgroundColorSelect3") var forgroundColorSelect3:Int = 0
    @AppStorage("isUseAnimation") var isUseAnimation:Bool = false
    @AppStorage("animationStyleSelect") var animationStyleSelect:Int = 0

    struct Data {
        @AppStorage("renderingModeSelect") var renderingModeSelect:Int = 0
        @AppStorage("fontWeightSelect") var fontWeightSelect:Int = 0
        @AppStorage("forgroundColorSelect1") var forgroundColorSelect1:Int = 0
        @AppStorage("forgroundColorSelect2") var forgroundColorSelect2:Int = 0
        @AppStorage("forgroundColorSelect3") var forgroundColorSelect3:Int = 0
        @AppStorage("isUseAnimation") var isUseAnimation:Bool = false
        @AppStorage("animationStyleSelect") var animationStyleSelect:Int = 0

        var animationStyle:Option.AnimationStyle {
            Option.AnimationStyle.allCases[animationStyleSelect]
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
        
    let previewNames:[String]

    func makeImage(name:String) -> some View  {
        Image(systemName: name)
            .font(.system(size: 150 / CGFloat(previewNames.count), weight: data.fontWeight))
            .symbolRenderingMode(data.renderingMode)
            .foregroundStyle(data.forgroundColor.0, data.forgroundColor.1, data.forgroundColor.2)
    }
        
    var body: some View {
        Group {
            Section {
                LazyVGrid(columns: GridItem.makeGridItems(number: previewNames.count)) {
                    ForEach(previewNames, id:\.self) { previewName in
                        VStack {
                            if isUseAnimation {
                                switch Option.AnimationStyle.allCases[animationStyleSelect] {
                                case .pulse:
                                    makeImage(name: previewName).symbolEffect(.pulse)
                                case .appear:
                                    makeImage(name: previewName).symbolEffect(.appear.down.byLayer)
                                case .variableColor:
                                    makeImage(name: previewName).symbolEffect(.variableColor.cumulative.dimInactiveLayers)
                                    
                                
                                default:
                                    makeImage(name: previewName)
                                }
                            } else {
                                makeImage(name: previewName)
                            }
                                
                                
                                
                            if previewNames.count == 1 {
                                Text(previewName)
                            }
                        }
                    }
                }
            }
            Section {
                Toggle(isOn: $isUseAnimation) {
                    Text("use Animation")
                }
                if isUseAnimation {
                    Picker(selection:$animationStyleSelect) {
                        ForEach(0..<Option.AnimationStyle.allCases.count, id:\.self) { i in
                            Text(Option.AnimationStyle.allCases[i].rawValue)
                        }
                    } label : {
                        Text("animationStyle")
                    }
                }
            }
            Section {
                Picker(selection: $renderingModeSelect) {
                    ForEach(0..<Option.symbolRenderingModes.count, id:\.self) { i in
                        Text(Option.symbolRenderingModes[i].0)
                    }
                } label: {
                    Text("renderingMode")
                }
                                
                Picker(selection: $fontWeightSelect) {
                    ForEach(0..<Option.fontWeights.count, id:\.self) { i in
                        Text(Option.fontWeights[i].0)
                    }
                } label: {
                    Text("fontWeight")
                        .fontWeight(data.fontWeight)
                }
                
                Picker(selection: $forgroundColorSelect1) {
                    ForEach(0..<Option.colorList.count, id:\.self) { i in
                        Text(Option.colorList[i].0)
                    }
                } label: {
                    Text(isPallete ? "forground Color 1" : "forground Color")
                }
                .foregroundColor(data.forgroundColor.0)
                
                
                if isPallete {
                    Picker(selection: $forgroundColorSelect2) {
                        ForEach(0..<Option.colorList.count, id:\.self) { i in
                            Text(Option.colorList[i].0)
                        }
                    } label: {
                        Text("forground Color 2")
                    }
                    .foregroundColor(data.forgroundColor.1)
                    
                    
                    Picker(selection: $forgroundColorSelect3) {
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

