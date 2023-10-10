//
//  Option.swift
//  SFSymbolTest
//
//  Created by Changyeol Seo on 2023/08/07.
//

import Foundation
import SwiftUI


struct Option {
    
    enum AnimationStyle:String, CaseIterable  {
//        case appear = "appear"
        case bounce = "bounce"
        case pulse = "pulse"
        case variableColor = "variableColor"
//        case scale = "scale"
//        case replace = "replace"
//        case disappear = "disappear"
    }
    
    enum AnimationAnimate:String, CaseIterable {
        case wholeSymbol = "wholeSymbol"
        case byLayer = "byLayer"
    }
    
    enum AnimationDirection:String, CaseIterable {
        case up = "up"
        case down = "down"
    }
    
    enum AnimationVaribleStyle:String, CaseIterable {
        /** 누적*/
        case cumulative = "cumulative"
        /** 반복*/
        case iterative = "iterative"
    }
    
    enum AnimationInactiveLayers: String, CaseIterable {
        /** 어둡게*/
        case dimInactiveLayers = "dimInactiveLayers"
        /** 가리기*/
        case hideInactiveLayers = "hideInactiveLayers"
    }
    
    static let symbolRenderingModes:[(String,SymbolRenderingMode)] = [
        ("multicolor",.multicolor),
        ("hierarchical",.hierarchical),
        ("monochrome",.monochrome),
        ("palette",.palette)
    ]

    static let fontWeights:[(String,Font.Weight)] = [
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

    static let colorList:[(String,Color)] = [
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
    
    let renderingModeSelect:Int
    
    var renderingMode:(String,SymbolRenderingMode) {
        Option.symbolRenderingModes[renderingModeSelect]
    }
    
    let fontWeightSelect:Int
    
    var fontWeight:(String,Font.Weight) {
        Option.fontWeights[fontWeightSelect]
    }
    
    let forgroundColorSelect1:Int
    
    var forgroundColor1:(String,Color) {
        Option.colorList[forgroundColorSelect1]
    }
    
    let forgroundColorSelect2:Int
    
    var forgroundColor2:(String,Color) {
        Option.colorList[forgroundColorSelect2]
    }

    let forgroundColorSelect3:Int

    var forgroundColor3:(String,Color) {
        Option.colorList[forgroundColorSelect3]
    }

    var dicValue:[String:Int] {
        return [
            "renderingModeSelect":renderingModeSelect,
            "fontWeightSelect":fontWeightSelect,
            "forgroundColorSelect1":forgroundColorSelect1,
            "forgroundColorSelect2":forgroundColorSelect2,
            "forgroundColorSelect3":forgroundColorSelect3
        ]
    }
    
    init(renderingModeSelect: Int, fontWeightSelect: Int, forgroundColorSelect1: Int, forgroundColorSelect2: Int, forgroundColorSelect3: Int) {
        self.renderingModeSelect = renderingModeSelect
        self.fontWeightSelect = fontWeightSelect
        self.forgroundColorSelect1 = forgroundColorSelect1
        self.forgroundColorSelect2 = forgroundColorSelect2
        self.forgroundColorSelect3 = forgroundColorSelect3
    }
    
    init(dic:[String:Int]) {
        renderingModeSelect = dic["renderingModeSelect"] ?? 0
        fontWeightSelect = dic["fontWeightSelect"] ?? 0
        forgroundColorSelect1 = dic["forgroundColorSelect1"] ?? 0
        forgroundColorSelect2 = dic["forgroundColorSelect2"] ?? 0
        forgroundColorSelect3 = dic["forgroundColorSelect3"] ?? 0
    }
}
