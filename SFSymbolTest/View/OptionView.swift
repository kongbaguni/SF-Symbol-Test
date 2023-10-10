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
    @AppStorage("animationAnimateSelect") var animationAnimateSelect:Int = 0
    @AppStorage("animationDirectionSelect") var animationDirectionSelect:Int = 0
    @AppStorage("animationVaribleStyleSelect") var animationVaribleStyleSelect:Int = 0
    @AppStorage("animationInactiveLayersSelect") var animationInactiveLayersSelect:Int = 0
    @AppStorage("animationReversing") var animationReversing = false

    struct Data {
        @AppStorage("renderingModeSelect") var renderingModeSelect:Int = 0
        @AppStorage("fontWeightSelect") var fontWeightSelect:Int = 0
        @AppStorage("forgroundColorSelect1") var forgroundColorSelect1:Int = 0
        @AppStorage("forgroundColorSelect2") var forgroundColorSelect2:Int = 0
        @AppStorage("forgroundColorSelect3") var forgroundColorSelect3:Int = 0
        @AppStorage("isUseAnimation") var isUseAnimation:Bool = false
        @AppStorage("animationStyleSelect") var animationStyleSelect:Int = 0
        @AppStorage("animationAnimateSelect") var animationAnimateSelect:Int = 0
        @AppStorage("animationDirectionSelect") var animationDirectionSelect:Int = 0
        @AppStorage("animationVaribleStyleSelect") var animationVaribleStyleSelect:Int = 0
        @AppStorage("animationInactiveLayersSelect") var animationInactiveLayersSelect:Int = 0
        @AppStorage("animationReversing") var animationReversing = false
        
        var animationStyle:Option.AnimationStyle {
            Option.AnimationStyle.allCases[animationStyleSelect]
        }
        
        var animationAnimate:Option.AnimationAnimate {
            Option.AnimationAnimate.allCases[animationAnimateSelect]
        }
        
        var animationDirection:Option.AnimationDirection {
            Option.AnimationDirection.allCases[animationDirectionSelect]
        }
        
        var animatonVaribleStyle:Option.AnimationVaribleStyle {
            Option.AnimationVaribleStyle.allCases[animationVaribleStyleSelect]
        }
        
        var animationInactiveLayers:Option.AnimationInactiveLayers {
            Option.AnimationInactiveLayers.allCases[animationInactiveLayersSelect]
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
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            effectValue = UUID().uuidString
        }
        
        return Image(systemName: name)
            .font(.system(size: 150 / CGFloat(previewNames.count), weight: data.fontWeight))
            .symbolRenderingMode(data.renderingMode)
            .foregroundStyle(data.forgroundColor.0, data.forgroundColor.1, data.forgroundColor.2)
    }
        
    @State var effectValue:String = Date().formatted()
    var animatePicker: some View {
        Picker(selection: $animationAnimateSelect) {
            ForEach(0..<Option.AnimationAnimate.allCases.count, id:\.self) { i in
                Text(Option.AnimationAnimate.allCases[i].rawValue)
            }
        } label: {
            Text("Animate")
        }
    }
    
    var directionPicker: some View {
        Picker(selection: $animationDirectionSelect) {
            ForEach(0..<Option.AnimationDirection.allCases.count, id:\.self) { i in
                Text(Option.AnimationDirection.allCases[i].rawValue)
            }
        } label: {
            Text("Direction")
        }
    }
    
    var varibleStylePicker:some View {
        Picker(selection: $animationVaribleStyleSelect) {
            ForEach(0..<Option.AnimationVaribleStyle.allCases.count, id:\.self) {i in
                Text(Option.AnimationVaribleStyle.allCases[i].rawValue)
            }
        } label: {
            Text("Style")
        }
    }
    
    var inactiveLayersPicker: some View {
        Picker(selection: $animationInactiveLayersSelect) {
            ForEach(0..<Option.AnimationInactiveLayers.allCases.count, id:\.self) {i in
                Text(Option.AnimationInactiveLayers.allCases[i].rawValue)
            }
        } label: {
            Text("Inactive Layers")
        }

    }

    var reversingToggle: some View {
        Toggle(isOn: $animationReversing, label: {
            Text("Reversing")
        })
    }
    
    var body: some View {
        Group {
            Section {
                LazyVGrid(columns: GridItem.makeGridItems(number: previewNames.count)) {
                    ForEach(previewNames, id:\.self) { previewName in
                        VStack {
                            if isUseAnimation {
                                
                                switch Option.AnimationStyle.allCases[animationStyleSelect] {
                                case .bounce:
                                    switch Option.AnimationAnimate.allCases[animationAnimateSelect] {
                                    case .byLayer:
                                        switch Option.AnimationDirection.allCases[animationDirectionSelect] {
                                        case .up:
                                            makeImage(name: previewName).symbolEffect(.bounce.up.byLayer, options: .repeating, value: effectValue)
                                        case .down:
                                            makeImage(name: previewName).symbolEffect(.bounce.down.byLayer, options: .repeating, value: effectValue)
                                        }
                                    case .wholeSymbol:
                                        switch Option.AnimationDirection.allCases[animationDirectionSelect] {
                                        case .up:
                                            makeImage(name: previewName).symbolEffect(.bounce.up.wholeSymbol, options: .repeating, value: effectValue)
                                        case .down:
                                            makeImage(name: previewName).symbolEffect(.bounce.down.wholeSymbol, options: .repeating, value: effectValue)
                                        }
                                    }
                                    
                                case .pulse:
                                    switch Option.AnimationAnimate.allCases[animationAnimateSelect] {
                                    case .byLayer:
                                        makeImage(name: previewName).symbolEffect(.pulse.byLayer,  options: .repeating, value: effectValue)
                                    case .wholeSymbol:
                                        makeImage(name: previewName).symbolEffect(.pulse.wholeSymbol,  options: .repeating, value: effectValue)
                                    }
                                case .variableColor:
                                    switch Option.AnimationVaribleStyle.allCases[animationVaribleStyleSelect] {
                                    case .cumulative:
                                        switch Option.AnimationInactiveLayers.allCases[animationInactiveLayersSelect] {
                                        case .dimInactiveLayers:
                                            if animationReversing {
                                                makeImage(name: previewName).symbolEffect(.variableColor.cumulative.dimInactiveLayers.reversing)
                                            }
                                            else {
                                                makeImage(name: previewName).symbolEffect(.variableColor.cumulative.dimInactiveLayers.nonReversing)
                                            }
                                        case .hideInactiveLayers:
                                            if animationReversing {
                                                makeImage(name: previewName).symbolEffect(.variableColor.cumulative.hideInactiveLayers.reversing)
                                            } else {
                                                makeImage(name: previewName).symbolEffect(.variableColor.cumulative.hideInactiveLayers.nonReversing)
                                            }
                                        }
                                        
                                    case .iterative:
                                        
                                        switch Option.AnimationInactiveLayers.allCases[animationInactiveLayersSelect] {
                                        case .dimInactiveLayers:
                                            if animationReversing {
                                                makeImage(name: previewName).symbolEffect(.variableColor.iterative.dimInactiveLayers.reversing)
                                            }
                                            else {
                                                makeImage(name: previewName).symbolEffect(.variableColor.iterative.dimInactiveLayers.nonReversing)
                                            }
                                        case .hideInactiveLayers:
                                            if animationReversing {
                                                makeImage(name: previewName).symbolEffect(.variableColor.iterative.hideInactiveLayers.reversing)
                                            } else {
                                                makeImage(name: previewName).symbolEffect(.variableColor.iterative.hideInactiveLayers.nonReversing)
                                            }
                                        }
                                    }
                                    
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
                    
                    let style = Option.AnimationStyle.allCases[animationStyleSelect]
                    
                    switch style {
                    case .pulse:
                        animatePicker
                    case .variableColor:
                        varibleStylePicker
                        inactiveLayersPicker
                        reversingToggle
                    default:
                        animatePicker
                        directionPicker
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
        .onAppear {
            effectValue = UUID().uuidString
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

