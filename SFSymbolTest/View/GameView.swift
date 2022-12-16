//
//  GameView.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/16.
//

import SwiftUI

struct GameView: View {
    let option:OptionView.Data = .init()
    let timer = STimer.shared
    @State var onYourMark = GameManager.shared.isGameOver == false
    @State var gameModel:GameModel? = nil
    @State var current:Int? = nil
    @State var worrongAnser = false
    @State var timeInterval:TimeInterval = 0.0 {
        didSet {
            var getDiscount: Text {
                let count = 10 - timeInterval
                if count < 0 {
                    return Text("0.0")
                } else {
                    return Text(String(format: "%0.1f", 10.0 - timeInterval))
                }
            }
            discount = getDiscount
        }
    }
    @State var discount:Text = Text("0.0")
    @State var isPause = false
    
    @State var 맞춘문제들:[String] = []
    @State var 틀린문제들:[String] = []
    
    @State var isGameOver:Bool = false
        
        
    var pausedView : some View {
        VStack {
            Text("Paused!")
                .padding(20)
                .font(.system(size:20,weight:.bold))
                .foregroundColor(Color.primary)
            
            Image(systemName: "timer.circle")
                .symbolRenderingMode(option.renderingMode)
                .font(.system(size: 150, weight: option.fontWeight))
                .frame(width: 300,height: 200)
                .foregroundStyle(option.forgroundColor.0,option.forgroundColor.1,option.forgroundColor.2)
            
            Button {
                timer.resume()
                isPause = false
            } label: {
                Text("Resume Game")
            }
        }
    }
    
    func makeGameView(gameModel:GameModel)-> some View {
        VStack {
            HStack {
                Image(systemName: "timer")
                    .symbolRenderingMode(option.renderingMode)
                    .font(.system(size: 30, weight: option.fontWeight))
                    .foregroundStyle(option.forgroundColor.0,option.forgroundColor.1,option.forgroundColor.2)

                discount
                    .font(.system(size:30, weight: .heavy))
                    .foregroundColor(timeInterval > 7 ? .red : .primary)
                Spacer()
            }.padding(15)
            
            Image(systemName: gameModel.정답)
                .symbolRenderingMode(option.renderingMode)
                .font(.system(size: 150, weight: option.fontWeight))
                .frame(width: 300,height: 200)
                .foregroundStyle(option.forgroundColor.0,option.forgroundColor.1,option.forgroundColor.2)
            
            ForEach(0..<gameModel.제시어.count, id:\.self) { i in
                Button {
                    if worrongAnser {
                        return
                    }
                    let duration = timer.duration
                    if gameModel.답안제시(번호: i) {
                        print("정답")
                        current = i
                        timer.stop()
                        if GameManager.shared.insert(문제: gameModel.정답, 맞춤: true, duration: duration) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                makeNewGame()
                            }
                        }
                    } else {
                        print("오답")
                        worrongAnser = true
                        current = gameModel.답번호
                        timer.stop()
                        if GameManager.shared.insert(문제: gameModel.정답, 맞춤: false, duration : duration) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                makeNewGame()
                            }
                        }
                    }
                    
                } label: {
                    Text(gameModel.제시어[i])
                        .foregroundColor(.primary)
                        .font(.system(size: 15))
                }
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke( i == current ? .green : worrongAnser ? .red : .secondary, lineWidth: 4)
                        .opacity(0.7)
                }
                .padding(5)
                .onAppear {
                    regTimerObserver()
                }
            }
        }
    }
    
    var historyView: some View {
        Group {
            //정답
            if 맞춘문제들.count > 0 {
                LazyVGrid(columns:GridItem.makeGridItems(number: 10)) {
                    ForEach(0..<맞춘문제들.count, id:\.self) { i in
                        let name = 맞춘문제들[i]
                        Image(systemName: name)
                            .symbolRenderingMode(.monochrome)
                            .foregroundStyle(Color.primary)
                    }
                }
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.secondary,lineWidth: 4)
                }
                .padding(5)
            }
            // 오답
            if 틀린문제들.count > 0 {
                LazyVGrid(columns:GridItem.makeGridItems(number: 10)) {
                    ForEach(0..<틀린문제들.count, id:\.self) { i in
                        let name = 틀린문제들[i]
                        Image(systemName: name)
                            .symbolRenderingMode(.monochrome)
                            .foregroundStyle(Color.red)
                    }
                }
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.secondary,lineWidth: 4)
                }
                .padding(5)
            }
        }
    }
    
    var onYourMarkView : some View {
        Group {
            Text("Readay")
                .font(.system(size: 20, weight: .heavy))
                .foregroundColor(Color.mint)
                .padding(20)
            
            Image(systemName: "flag.checkered")
                .symbolRenderingMode(option.renderingMode)
                .foregroundStyle(option.forgroundColor.0,option.forgroundColor.1,option.forgroundColor.2)
                .font(.system(size: 100,weight: option.fontWeight))
            
            Button {
                makeNewGame()
                onYourMark = false
            } label: {
                Text("Start!")
                    .font(.system(size: 20, weight: .heavy))
            }.padding(20)
        }
    }
    var gameOverView: some View {
        Group {
            Text("Game Over")
                .font(.system(size: 25,weight: .heavy))
                .foregroundColor(.red)
                .padding(25)
            
            Image(systemName: "flag.checkered.2.crossed")
                .symbolRenderingMode(option.renderingMode)
                .foregroundStyle(option.forgroundColor.0,option.forgroundColor.1,option.forgroundColor.2)
                .font(.system(size: 100,weight: option.fontWeight))
                .padding(.bottom,20)
            
            HStack {
                Text("duration : ")
                    .foregroundColor(.secondary)
                Text(String(format: "%0.1f",GameManager.shared.duration))
                    .foregroundColor(.primary)
            }
            HStack {
                Text("point : ")
                    .foregroundColor(.secondary)
                Text(GameManager.shared.point.decimalFormatted)
                    .foregroundColor(.primary)
            }
            HStack {
                Text("time bonus : ")
                    .foregroundColor(.secondary)
                Text(GameManager.shared.timeBonus.decimalFormatted)
                    .foregroundColor(.primary)
            }
            HStack {
                Text("total : ")
                    .foregroundColor(.secondary)
                Text(GameManager.shared.totalPoint.decimalFormatted)
                    .foregroundColor(.primary)
            }

            Button {
                GameManager.shared.clear()
                맞춘문제들.removeAll()
                틀린문제들.removeAll()
                onYourMark = true
                isGameOver = false
            } label : {
                Text("retry")
                    .padding(20)
                    .font(.system(size:20))
            }
        }
    }
    
    var body: some View {
        ScrollView {
            if isGameOver {
                gameOverView
            }
            else if onYourMark {
                onYourMarkView
            }
            else if isPause {
                pausedView
            }
            else if let gameModel = gameModel {
                makeGameView(gameModel: gameModel)
            }
            historyView
        }
        .onAppear {
            onYourMark = GameManager.shared.isGameOver == false
            isGameOver = GameManager.shared.isGameOver
        }
        .onDisappear{
            timer.stop()
        }
        .navigationTitle(Text("Game"))
    }
    
    func makeNewGame() {
        맞춘문제들 = GameManager.shared.맞춤
        틀린문제들 = GameManager.shared.틀림
        print(맞춘문제들)
        print(틀린문제들)
        current = nil
        worrongAnser = false
        if let model = GameManager.shared.newGame() {
            self.gameModel = model
        }
        timer.start()
        timeInterval = timer.duration
    }
    
    @State var isRegTimmerObserver = false
    func regTimerObserver() {
        if isRegTimmerObserver {
            return
        }
        isRegTimmerObserver = true
        NotificationCenter.default.addObserver(forName: .sTimerDidUpdate, object: nil, queue: nil) { noti in
            DispatchQueue.main.async {
                isGameOver = GameManager.shared.isGameOver
                if isGameOver || onYourMark {
                    return
                }
                self.timeInterval = timer.duration
                isPause = timer.isPause
                print("\(#function) \(timer.id) \(timer.duration)")
                guard let game = gameModel else {
                    return
                }
                if timeInterval > 10 {
                    let duration = timer.duration
                    timer.stop()
                    current = game.답번호
                    worrongAnser = true
                    if GameManager.shared.insert(문제: game.정답, 맞춤: false, duration: duration) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                            makeNewGame()
                        }
                    }
                    
                }

            }
        }
    }
        
}

