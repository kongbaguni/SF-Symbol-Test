//
//  GameManager.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/16.
//
import GameKit
import Foundation
import GameKit
import SwiftUI

fileprivate var leaderBoardId:String {
    return "grp.SFSymbol.leaderboard"
}
extension Notification.Name {
    static let gameOver = Notification.Name("gameOver_observer")
    static let pointPostFinish = Notification.Name("pointPostFinish_observer")
}

class GameManager  : NSObject {
    static let 게임오버기준 = 10
    static let 문항갯수 = 5
    
    static let shared = GameManager()
    weak var leaderBoardController : UIViewController? = nil
     
    func authuser(complete:@escaping()->Void) {
        let localplayer = GKLocalPlayer.local
        localplayer.authenticateHandler = { _, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            GKAccessPoint.shared.location = .topLeading
            GKAccessPoint.shared.isActive = localplayer.isAuthenticated
            complete()
        }
    }
    
    func updateLeaderboard(totalPoint:Int, id:String, complete:@escaping(_ isSucess:Bool)->Void) {
        guard GKLocalPlayer.local.isAuthenticated else {
            complete(false)
            return
        }
        
        GKLeaderboard.submitScore(totalPoint, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [id]) { error in
            complete(error == nil)
            if error == nil {
                NotificationCenter.default.post(name: .pointPostFinish, object: nil)
            }
        }
        
    }
    
    
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
        
    private var _맞춤:[String] = [] {
        didSet {
            if isGameOver {
                NotificationCenter.default.post(name: .gameOver, object: nil)
            }
        }
    }
    public var 맞춤:[String] {
        get {
            return _맞춤
        }
    }
    
    private var _틀림:[String] = [] {
        didSet {
            if isGameOver {
                NotificationCenter.default.post(name: .gameOver, object: nil)
            }
        }
    }
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
    
    public var point:Int {
        var result = 0
        result += 맞춤.count * 10000
        result -= 틀림.count * 1000
        if result < 0 {
            return 0
        }
        return result
    }
    
    public var timeBonus:Int {
        if 맞춤.count == GameManager.게임오버기준 {
            var result:Int = 0
            for duration in _durations {
                if duration < 10 {
                    let a = Int(10 - duration)
                    result += (a * a) * 100
                }
            }
            return result
        }
        return 0
    }
    
    public var totalPoint:Int {
        point + timeBonus
    }

    public var isGameOver:Bool {
        맞춤.count >= GameManager.게임오버기준 || 틀림.count >= GameManager.게임오버기준 
    }
    
    public var isPerfectClear:Bool {
        틀림.count == 0 && 맞춤.count == GameManager.게임오버기준
    }
    
    public var allFaild:Bool {
        틀림.count == GameManager.게임오버기준 && 맞춤.count == 0
    }
    
    public enum AchivementType:String {
        case perfectClear =  "grp.SFSymbol.perfectClear"
        case allFaild = "grp.SFSymbol.allFaild"
    }
    
    public func reportAchivement(archivementType:AchivementType, complete:@escaping(_ error:Error?)->Void) {
        GKAchievement.loadAchievements { archivements, error in
            if let err = error {
                complete(err)
                return
            }
            
            if let archivements = archivements {
                if archivements.filter({ a in
                    return a.identifier == archivementType.rawValue
                }).count == 0 {
                    let achivement = GKAchievement.init(identifier: archivementType.rawValue, player: GKLocalPlayer.local)
                    achivement.percentComplete = 1.0
                    GKAchievement.report([achivement]) { error in
                        complete(error)
                    }
                }
            }
        }

    }
}








