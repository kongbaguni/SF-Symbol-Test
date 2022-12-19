//
//  RoundedButtonView.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/19.
//

import SwiftUI
struct RoundedButonStyle : ButtonStyle {
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
