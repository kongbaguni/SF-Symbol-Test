//
//  GridItem+Extensions.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/15.
//

import SwiftUI
extension GridItem {
    static func makeGridItems(number:Int)->[GridItem] {
        var result:[GridItem] = []
        for _ in 0..<number {
            result.append(GridItem(.flexible()))
        }
        return result
    }
    
}
