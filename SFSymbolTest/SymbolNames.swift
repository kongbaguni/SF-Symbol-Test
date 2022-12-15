//
//  SymbolNames.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/12.
//

import Foundation
import SwiftUI

let SFSymbolCategorys:[(String,String,Text)] = [
    ("all","square.grid.2x2",Text("all")),
    ("new","sparkles",Text("new")),
    ("multipleColor","paintpalette",Text("multipleColor")),
    ("variable","square.stack.3d.up",Text("variable")),
    ("communication","message",Text("communication")),
    ("weather","cloud.sun",Text("weather")),
    ("objectAndTools","folder",Text("objectAndTools"))
]

struct SFSymbol {
    @Binding var names:[String]

    func loadData(category:String = "all") {
        do {
            if let path = Bundle.main.path(forResource: "resorces/\(category)", ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path),options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let array = jsonResult as? [String] {
                    names = array
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}


