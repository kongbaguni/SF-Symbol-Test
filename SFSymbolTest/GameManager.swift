//
//  GameManager.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/16.
//

import Foundation
class GameManager {
    static let 게임오버기준 = 10
    static let 문항갯수 = 5
    
    static let shared = GameManager()
    var names:[String] = []
    var backup:[String] = []
    
    func insert(names:[String]) {
        self.backup = names.shuffled()
        self.names = names.shuffled()
    }
    
    func newGame()->GameModel? {
        if backup.count == 0 {
            return nil
        }
        if names.count < GameManager.문항갯수 {
            names = backup.shuffled()
        }
        let 정답 = self.names.popLast()!
        var 제시어:[String] = []
        while 제시어.count < GameManager.문항갯수 - 1 {
            제시어.append(self.names.popLast()!)
        }
        제시어.append(정답)
        
        return GameModel(정답: 정답, 제시어: 제시어.shuffled())
    }
    
    private var _durations:[TimeInterval] = []
    public var duration:TimeInterval {        
        var result:TimeInterval = 0
        for du in _durations {
            result += du
        }
        return result
    }
    
    private var _맞춤:[String] = []
    public var 맞춤:[String] {
        get {
            return _맞춤
        }
    }
    private var _틀림:[String] = []
    public  var 틀림:[String] {
        get {
            return _틀림
        }
    }
    
    func insert(문제:String,맞춤:Bool,duration:TimeInterval)->Bool {
        if 문제.isEmpty {
            return false
        }
        if 맞춤 {
            if _맞춤.last != 문제 {
                _맞춤.append(문제)
                _durations.append(duration)
                return true
            } else {
                return false
            }
        } else {
            if _틀림.last != 문제 {
                _틀림.append(문제)
                _durations.append(duration)
                return true
            } else {
                return false 
            }
            
        }
    }
    
    func clear() {
        _맞춤.removeAll()
        _틀림.removeAll()
        _durations.removeAll()
    }
}
