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
                    .foregroundColor(forgroundColor)
            }
            if numberOfHarfStar == 1 {
                Image(systemName: "star.leadinghalf.filled")
                    .foregroundColor(forgroundColor)
            }
            ForEach(0..<5-(numberOfHarfStar + numberOfFullStar), id:\.self) { _ in
                Image(systemName: "star")
                    .foregroundColor(forgroundColor)
            }
        }
    }
}

struct StarView_Previews: PreviewProvider {
    static var previews: some View {
        StarView(numberOfStar: 3.5, forgroundColor: .yellow)
    }
}
