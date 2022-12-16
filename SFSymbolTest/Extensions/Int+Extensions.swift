//
//  Int+Extensions.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/16.
//

import Foundation
extension Int {
    var decimalFormatted:String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(for: self) ?? ""
    }
}
