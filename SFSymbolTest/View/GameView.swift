//
//  GameView.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/16.
//

import SwiftUI
import GameKit

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    enum GameMode {
        case 글자고르기
        case 그림고르기
    }
    
    var leaderBoardId:String {
        return "grp.SFSymbol.leaderboard"
    }
    
    let mode:GameMode
    let option:OptionView.Data = .init()
    let timer = STimer.shared
    @State var onYourMark = GameManager.shared.isGameOver == false
    @State var gameModel:GameModel? = nil
    @State var current:Int? = nil
    @State var worrongAnser = false
    @State var isAlert = false
    @State var alertMessage:Text? = nil
    @State var isHaveFinalPoint = false
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
    @State var isShowGameCenterView:Bool = false
    @State var gameCenterState:GKGameCenterViewControllerState = .leaderboards
        
    @State var isToast:Bool = false
    @State var toastMessage:String = ""
        
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
                        
            RoundedButtonView(text: Text("Resume Game"), style: .normalStyle) {
                timer.resume()
                isPause = false
            }
        }
    }
    
    func makeGameView(gameModel:GameModel)-> some View {
        VStack {
            HStack {
                Button {
                    timer.pause()
                    isPause = true
                } label : {
                    Image(systemName: "timer")
                        .symbolRenderingMode(option.renderingMode)
                        .font(.system(size: 30, weight: option.fontWeight))
                        .foregroundStyle(option.forgroundColor.0,option.forgroundColor.1,option.forgroundColor.2)
                    
                    discount
                        .font(.system(size:30, weight: .heavy))
                        .foregroundColor(timeInterval > 7 ? .red : .primary)
                }
                Spacer()
            }.padding(15)
            switch mode {
                case .글자고르기:
                    Image(systemName: gameModel.정답)
                        .symbolRenderingMode(option.renderingMode)
                        .font(.system(size: 150, weight: option.fontWeight))
                        .frame(width: 300,height: 200)
                        .foregroundStyle(option.forgroundColor.0,option.forgroundColor.1,option.forgroundColor.2)
                case .그림고르기:
                    MultiFontWeightTextButtonView(title: gameModel.정답.uppercased(), separatedBy: ".", style: .init(strokeColor: (Color.clear,Color.clear), backgroundColor: (.clear,.clear), foregroundColor: (.primary,.primary))) {
                        
                    }
            }
            switch mode {
                case .글자고르기:
                    ForEach(0..<gameModel.제시어.count, id:\.self) { i in
                        MultiFontWeightTextButtonView(title: gameModel.제시어[i].uppercased(),
                                                      separatedBy: ".",
                                                      style: .init(strokeColor: (i == current ? .yellow : worrongAnser ? .orange : .gray, .blue),
                                                                   backgroundColor: ( i == current ? .blue : worrongAnser ? .red : .white, .yellow),
                                                                   foregroundColor: ( i == current ? .yellow : worrongAnser ? .white : .black, .blue))) {
                            
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
                        }.padding(5)
                    }
                case .그림고르기:
                    LazyVGrid(columns: [.init(.flexible()),.init(.flexible()),.init(.flexible())]) {
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
                                Image(systemName: gameModel.제시어[i])
                                    .symbolRenderingMode(option.renderingMode)
                                    .font(.system(size: 50, weight: option.fontWeight))
                                    .frame(width: 80,height: 80)
                                    .foregroundStyle(option.forgroundColor.0,option.forgroundColor.1,option.forgroundColor.2)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(i == current ? Color.blue : worrongAnser ? Color.red : Color.secondary, lineWidth:6)
                                            .opacity(i == current || worrongAnser ? 1.0 : 0.2)
                                    }
                                    .padding(.bottom,20)
                            }
                        }

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
        OnYourMarkView(isShowGameCenterView: $isShowGameCenterView,
                       gameCenterState: $gameCenterState,
                       option:option,
                       leaderBoardId:leaderBoardId) {
            makeNewGame()
            onYourMark = false
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
            
            HStack {
                if isHaveFinalPoint {
                    RoundedButtonView(text: Text("Report Points"), style: .normalStyle) {
                        submitLeaderboard()
                    }
                } else {
                    RoundedButtonView(text: Text("leaderboard"), style: .normalStyle) {
                        isShowGameCenterView = true
                        gameCenterState = .leaderboards
                    }
                }
                RoundedButtonView(text: Text("retry"),
                                  style: .normalStyle) {
                    GameManager.shared.clear()
                    맞춘문제들.removeAll()
                    틀린문제들.removeAll()
                    onYourMark = true
                    isGameOver = false
                }
            }.padding(10)
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
            isHaveFinalPoint = GameManager.shared.point > 0
            GKLocalPlayer.local.authenticateHandler = { viewController, error in
                if let err = error {
                    isAlert = true
                    alertMessage = Text(err.localizedDescription)
                }
                if let vc = viewController {
                    UIApplication.shared.lastViewController?.present(vc, animated: true)
                }
                
            }
        }
        .onDisappear{
            timer.stop()
            if GameManager.shared.isGameOver {
                GameManager.shared.clear()
            }
        }
        .navigationTitle(Text("Game"))
        .alert(isPresented: $isAlert) {
            Alert(title: Text("alert"), message: alertMessage)
        }
        .sheet(isPresented: $isShowGameCenterView, content: {
            GameCenterViewController(state: gameCenterState)
        })
        .toast(message: toastMessage, isShowing: $isToast, duration: 3.0)
        .onReceive(NotificationCenter.default.publisher(for: .sTimerDidUpdate)) { noti in
            DispatchQueue.main.async {
                isGameOver = GameManager.shared.isGameOver
                if isGameOver || onYourMark {
                    return
                }
                self.timeInterval = timer.duration
                isPause = timer.isPause
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .gameOver)) { noti in
            isHaveFinalPoint = true
            if GameManager.shared.isPerfectClear {

                GameManager.shared.reportAchivement(archivementType: .perfectClear) { error in
                    if let err = error {
                        isAlert = true
                        alertMessage = Text(err.localizedDescription)
                    } else {
                        isShowGameCenterView = true
                        gameCenterState = .challenges
                    }
                }
            }
            if GameManager.shared.allFaild {
                
                GameManager.shared.reportAchivement(archivementType: .allFaild) { error in
                    if let err = error {
                        isAlert = true
                        alertMessage = Text(err.localizedDescription)
                    } else {
                        isShowGameCenterView = true
                        gameCenterState = .challenges
                    }
                }
            }

        }
        .onReceive(NotificationCenter.default.publisher(for: .pointPostFinish)) { noti in
            isHaveFinalPoint = false
        }
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
    
    
    private func submitLeaderboard() {
        GameManager.shared.updateLeaderboard(totalPoint: GameManager.shared.totalPoint, id: leaderBoardId) {isSucess in
            if isSucess {
                isHaveFinalPoint = false
            }
        }
    }
        
}

