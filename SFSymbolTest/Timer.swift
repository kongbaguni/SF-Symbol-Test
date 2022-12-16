//
//  Timer.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/16.
//

import SwiftUI
extension Notification.Name {
    static let sTimerDidUpdate = Notification.Name("sTimerDidUpdate_observer")
}

class STimer {
    static let shared = STimer()
    init() {
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { [weak self] noti in
            self?.pause()
        }
    }
    let id = UUID().uuidString
    func update() {
        guard begainDate != nil && stopDate == nil else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { [weak self] in
            NotificationCenter.default.post(name: .sTimerDidUpdate, object: self?.duration)
            self?.update()
        }
    }
    
    private var begainDate:Date? = nil
    private var stopDate:Date? = nil
    
    private var pauseDate:Date? = nil
    private var pauses:[(Date,Date)] = []
        
    public func start() {
        begainDate = Date()
        pauseDate = nil
        stopDate = nil
        pauses.removeAll()
        update()
    }
    
    public func stop() {
        stopDate = Date()
    }
    
    public func pause() {
        guard begainDate != nil else {
            return
        }
        pauseDate = Date()
    }
    
    public func resume() {
        guard let pause = pauseDate else {
            return
        }
        pauses.append((pause,Date()))
        pauseDate = nil
    }
    
    var isPause:Bool {
        pauseDate != nil
    }
    
    var duration:TimeInterval {
        if let begain = begainDate {
            let now = (stopDate ?? Date()).timeIntervalSince1970
            var duration = now - begain.timeIntervalSince1970
            for item in pauses {
                let pauseTime = item.1.timeIntervalSince1970 - item.0.timeIntervalSince1970
                duration -= pauseTime
            }
            if let date = pauseDate {
                duration -= (now - date.timeIntervalSince1970)
            }
            return duration
        }
        return 0
    }
}
