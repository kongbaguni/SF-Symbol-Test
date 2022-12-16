//
//  GameModel.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/16.
//

import Foundation
import SwiftUI

struct GameModel {
    let 정답:String
    let 제시어:[String]
    
    func 답안제시(번호:Int)->Bool {
        if (번호 > 제시어.count || 번호 < 0) {
            return false
        }
        return 제시어[번호] == 정답
    }
    
    var 답번호:Int {
        return 제시어.firstIndex(of: 정답)!
    }
}

