//
//  GameRunView.swift
//  potatosport
//
//  Created by 蔡瑀 on 2022/6/22.
//

import SwiftUI
import SceneKit
import FirebaseDatabase
import FirebaseDatabaseSwift


var classifier = "none"

struct GameMasonView:View{
    
//    @State private var GameState:Int = 0
    
    @State private var show3:Bool = true
    @State private var show2:Bool = false
    @State private var show1:Bool = false
    @State private var showstart:Bool = false
    @State private var finish = false
    
    
    @State private var posZ:Float = 0
    @EnvironmentObject var roomConnetModel : roomsConnetModel
    
    @EnvironmentObject var gameConnect : gameConnectViewModel

    @State private var giftShowLeft = true //  1右 2左 3都有
    @State private var status = "left"
    var body: some View{
        ZStack{
            if self.gameConnect.gameState == 0{
                IntroView()
            }
            if self.gameConnect.gameState == 5{
                FinalView()
            }
            if self.gameConnect.gameState != 5 && self.gameConnect.gameState != 0 {
                ZStack(alignment: .center){
                    MasonTurnView()
                    if self.gameConnect.gameState == 1{
                        Text("請讓鏡頭能夠偵測到您的全身")
                            .foregroundColor(Color("white"))
                            .fontWeight(.black)
                            .font(.system(size: 45))
                            .frame(width: 680, height: 63)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(10)
                    }
                    if self.gameConnect.gameState == 2{
                        Text("做得好！\n接著，來試試看梅森轉體吧！")
                            .foregroundColor(Color("white"))
                            .fontWeight(.black)
                            .font(.system(size: 45))
                            .frame(width: 680, height: 126)
                            .background(Color("lightgreen").opacity(0.8))
                            .cornerRadius(10)
                    }
                    if self.gameConnect.gameState == 3{
                        Text("太棒了！比賽即將開始！")
                            .foregroundColor(Color("white"))
                            .fontWeight(.black)
                            .font(.system(size: 45))
                            .frame(width: 680, height: 63)
                            .background(Color("yellow_500").opacity(0.5))
                            .cornerRadius(10)
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline:.now()+5){
                                    print("switch state to \(gameConnect.gameState)")
                                }
                            }
                    }
                    if self.gameConnect.gameState == 4{
                        ZStack{
                            // 遊戲
                            Image("potato_right")
                                .resizable()
                                .frame(width: 318, height: 178)
                                .offset(x: 300, y: 100)
                            if startgame{
                                if !giftShowLeft {
                                    Image("gift")
                                        .resizable()
                                        .frame(width: 95, height: 123)
                                        .offset(x: 200, y: 0)
                                }
                                else   {
                                    Image("gift")
                                        .resizable()
                                        .frame(width: 95, height: 123)
                                        .offset(x: -200, y: 0)
                                }
                            }
                            Image("potato_left")
                                .resizable()
                                .frame(width: 318, height: 178)
                                .offset(x: -300, y: 100)
                            
                            if self.show3{
                                Image("game_3")
                                    .onAppear{
                                    DispatchQueue.main.asyncAfter(deadline:.now()+1){
                                        self.show3 = false
                                        self.show2 = true
                                    }
                                    
                                }
                            }
                            if self.show2{
                                Image("game_2")
                                .onAppear{
                                    DispatchQueue.main.asyncAfter(deadline:.now()+1){
                                        self.show2 = false
                                        self.show1 = true
                                    }
                                    
                                }
                            }
                            if self.show1{
                                Image("game_1")
                                .onAppear{
                                    DispatchQueue.main.asyncAfter(deadline:.now()+1){
                                        self.show1 = false
                                        self.showstart = true
                                    }
                                    
                                }
                            }
                            if self.showstart{
                                Image("game_start")
                                .onAppear{
                                    DispatchQueue.main.asyncAfter(deadline:.now()+1){
                                        self.showstart = false
                                        startgame = true
                                        self.gameConnect.gameClock()
                                        self.Update()
                                    }
                                    
                                }
                            }
                            if startgame == true {
                                if finish {
                                    StrokeText(text: "時間到", width: 5, borderColor: Color.white, fontColor: Color("yellow_main"))
                                } else{
                                    StrokeText(text: String(self.gameConnect.time), width: 5, borderColor: Color.white, fontColor: Color("yellow_main"))
                                }
                                    
                                    
                            }
                            
                                
                        }
                        
                    }
                }
            }
            
        }.onAppear{
            var ref = Database.database().reference()
            ref.child("rooms").removeAllObservers()
            self.CheckGameState()
        }
        
    }
    
    func CheckGameState(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            //print("CheckGameState")
            if scanbody == true && gameConnect.gameState == 1{
                gameConnect.gameState = 2
            }
            if classifier == "none" && gameConnect.gameState == 2{
                gameConnect.gameState = 3
            }
            CheckGameState()
            
        }
    }
    func Update(){
        var clock = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            //print("CheckGameState")
            if status == "right" && classifier == "left" {
                self.giftShowLeft = true
            }
            if giftShowLeft {
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
                    // Your function here
                    clock += 1
                    if(clock > 1){
                        self.giftShowLeft = false
                    }
                })
            }
            if self.gameConnect.gameState != 5 {
                Update()
            }
            
        }
    }

}

