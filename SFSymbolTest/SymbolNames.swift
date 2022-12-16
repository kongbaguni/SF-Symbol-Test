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
    ("objectAndTools","folder",Text("objectAndTools")),
    ("device","desktopcomputer",Text("device")),
    ("game","gamecontroller",Text("game")),
    ("connect","antenna.radiowaves.left.and.right",Text("connect")),
    ("traffic","car",Text("traffic")),
    ("car","steeringwheel",Text("car")),
    ("assisitive","figure.roll",Text("assisitive")),
    ("privacyAndSecurity","lock",Text("privacyAndSecurity")),
    ("person","person.circle",Text("person")),
    ("home","house",Text("home")),
    ("fitness","figure.cooldown",Text("fitness")),
    ("nature","tree",Text("nature")),
    ("edit","slider.horizontal.3",Text("edit")),
    ("textFormat","textformat",Text("textFormat")),
    ("media","playpause",Text("media")),
    ("keyboard","command",Text("keyboard")),
    ("commerce","cart",Text("commerce")),
    ("time","timer",Text("time")),
    ("health","heart",Text("health")),
    ("figure","square.on.square",Text("figure")),
    ("arrow","arrow.right",Text("arrow")),
    ("index","a.circle",Text("index")),
    ("math","x.squareroot",Text("math"))
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


