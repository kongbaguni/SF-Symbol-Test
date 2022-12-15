//
//  SymbolNames.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/12.
//

import Foundation
import SwiftUI

struct SFSymbol {
    @Binding var names:[String]

    func loadData() {
        do {
            if let path = Bundle.main.path(forResource: "resorces/sf_symbol_names_all", ofType: "json") {
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


