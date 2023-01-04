//
//  StarView.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2023/01/03.
//

import SwiftUI

struct StarView: View {
    let numberOfStar:NSDecimalNumber
    let forgroundColor:Color
    let size:CGSize
    var numberOfFullStar:Int {
        Int(truncating: numberOfStar)
    }
    var numberOfHarfStar:Int {
        NSDecimalNumber(value:numberOfFullStar) == numberOfStar ? 0 : 1
    }
    var body: some View {
        HStack {
            ForEach(0..<numberOfFullStar, id:\.self) { _ in
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: size.width, height:size.height)
                    .scaledToFit()
                    .foregroundColor(forgroundColor)
            }
            if numberOfHarfStar == 1 {
                Image(systemName: "star.leadinghalf.filled")
                    .resizable()
                    .frame(width: size.width, height:size.height)
                    .scaledToFit()
                    .foregroundColor(forgroundColor)
            }
            ForEach(0..<5-(numberOfHarfStar + numberOfFullStar), id:\.self) { _ in
                Image(systemName: "star")
                    .resizable()
                    .frame(width: size.width, height:size.height)
                    .scaledToFit()
                    .foregroundColor(forgroundColor)
            }
        }.frame(height:size.height)
    }
}

struct StarView_Previews: PreviewProvider {
    static var previews: some View {
        StarView(numberOfStar: 3.5, forgroundColor: .yellow, size: .init(width: 12, height: 12))
    }
}
