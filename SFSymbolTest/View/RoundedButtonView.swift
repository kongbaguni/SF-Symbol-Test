//
//  RoundedButtonView.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/19.
//

import SwiftUI

struct RoundedButonStyle : ButtonStyle {
    static let normalStyle:RoundedButonStyle = .init(strokeColor: (Color.blue, Color.green),
                                                    backgroundColor: (Color.mint, Color.yellow),
                                                    foregroundColor: (Color.blue, Color.red))
    let strokeColor:(Color,Color)
    let backgroundColor:(Color,Color)
    let foregroundColor:(Color,Color)
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? foregroundColor.1 : foregroundColor.0)
            .padding(10)
            .background(configuration.isPressed ? backgroundColor.1 : backgroundColor.0)
            .cornerRadius(20)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(configuration.isPressed ?  strokeColor.1 : strokeColor.0, lineWidth: 5)
            }
    }
}

struct RoundedButtonView: View {
    let text:Text
    let style:RoundedButonStyle
    let action:()->Void
    
    var body: some View {
        Button {
            action()
        } label: {
            text
        }.buttonStyle(style)
    }
}

struct MultiFontWeightTextButtonView  : View {
    let title:String
    let separatedBy:String
    let style:RoundedButonStyle
    let action:()->Void
    var attributedString:AttributedString {
        var result:String = ""
        for (index,str) in title.components(separatedBy: separatedBy).enumerated() {
            if index > 0 {
                result.append(" \(separatedBy) ")
            }
            result.append("**\(str)**")
        }
        var attr = try! AttributedString(markdown: result)
        return attr
    }
    var body : some View {
        Button {
            action()
        } label : {
            Text(attributedString)
        }.buttonStyle(style)
    }
}
