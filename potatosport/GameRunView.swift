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

var pos:Float = 0
var scanbody:Bool = false
var running:Bool = false
var startgame:Bool = false

struct GameRunView:View{

    
    @State private var show3:Bool = true
    @State private var show2:Bool = false
    @State private var show1:Bool = false
    @State private var showstart:Bool = false
    @State private var finish = false
    
    @EnvironmentObject var roomConnetModel : roomsConnetModel
    
    @EnvironmentObject var gameConnect : gameConnectViewModel
    
    @EnvironmentObject var musicControl:musicControl
    
    //取得場景物件
    var scene = SCNScene(named: "Game.scn")
    var cameraNode:SCNNode?{
        scene?.rootNode.childNode(withName: "camera", recursively: false)
    }
    var SphereNode:SCNNode?{
        scene?.rootNode.childNode(withName: "player", recursively: false)
    }
    var SphereNodeFr:SCNNode?{
        scene?.rootNode.childNode(withName: "player1", recursively: false)
    }
    
    var body: some View{
        ZStack{
            if self.gameConnect.gameState == 0{
                IntroView()
            }
            if self.gameConnect.gameState == 5{
                FinalView()
            }
            if self.gameConnect.gameState != 5 && self.gameConnect.gameState != 0 && self.gameConnect.gameState != 4 {
                ZStack(alignment: .center){
                    RunActionView()
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
                        Text("做得好！\n接著，來試試看提膝奔跑吧！")
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
//                                    self.gameConnect.setReady()
                                    self.gameConnect.gameState = 4
                                    print("switch state to \(gameConnect.gameState)")
                                }
                            }
                    }
                }
            }
            if self.gameConnect.gameState == 4{
                ZStack{
                    SceneView(
                        scene:scene,
                        pointOfView:cameraNode,
                        options:[.allowsCameraControl]
                    ).frame(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
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
                                self.InitPos()
                                self.UpdatePos()
                                self.gameConnect.gameClock()
                                self.musicControl.gameBgm()
                            }
                            
                        }
                    }
                    if startgame == true {
                        if finish {
                            StrokeText(text: "抵達終點", width: 5, borderColor: Color.white, fontColor: Color("yellow_main"))
                        }else{
                            StrokeText(text: String(self.gameConnect.time), width: 5, borderColor: Color.white, fontColor: Color("yellow_main"))
                        }
                            
                            
                    }
                    
                        
                }
                
            }
            
        }.onAppear{
            self.roomConnetModel.removeRoomObserve()
            self.gameConnect.roomId = self.roomConnetModel.roomId
            self.gameConnect.myId = self.roomConnetModel.myId
            // 是不是單人玩
            if self.roomConnetModel.selfPlyaers.count < 2 {
                self.gameConnect.single = true
            }
            self.gameConnect.observeGamePoint()
            self.CheckGameState()
            musicControl.mainbg.pause()
        }
        
    }
    
    func CheckGameState(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            //print("CheckGameState")
            if scanbody == true && gameConnect.gameState == 1{
                gameConnect.gameState = 2
                print("switch state to \(gameConnect.gameState)")
            }
            if running == true && gameConnect.gameState == 2{
                gameConnect.gameState = 3
                self.gameConnect.setReady()
                print("switch state to \(gameConnect.gameState)")
            }
            CheckGameState()
            
        }
    }
    
//    //設定初始位置
//    func InitPos(){
//        SphereNode?.position = SCNVector3(-0.632,0,0)
////        SphereNodeFr?.position = SCNVector3(1.06,0,0)
//    }
//
//    func UpdatePos() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            //print("-----> UpdatePos")
//            SphereNode?.position = SCNVector3(-0.632,0,pos)
////            self.gameConnect.addPoint(posZ: pos)
//            if pos < -3 {
//                self.finish = true
//            }
//            UpdatePos()
//        }
//    }
    //設定初始位置
        func InitPos(){
            print("-----> 設定初始位置")
            SphereNode?.position = SCNVector3(x:-0.632,y:0.0,z:0)
            SphereNodeFr?.position = SCNVector3(x:1.67,y: 0,z: 0)
        }
        func UpdatePos() {
            
//            var tTimer = 0
//            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
//                // Your function here
//                tTimer += 1
//                print("UpdatePos",pos)
//                if pos < -3 {
//                    self.finish = true
//                    self.musicControl.finish()
//                    tTimer = 30
//                    SphereNode?.position = SCNVector3(x:-0.632,y:0.0,z:-3.0)
//
//                }else{
//                    SphereNode?.position = SCNVector3(x:-0.632,y:0.0,z:pos)
//                }
//                SphereNodeFr?.position = SCNVector3(x:1.67,y:0.0,z:self.gameConnect.frUserPos)
//                if tTimer >= 30 {
//                    timer.invalidate()
//                }
//
//            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                //print("-----> UpdatePos")
                if pos < -3 {
                    self.finish = true
                    self.musicControl.finish()
//                    SphereNode?.position = SCNVector3(-0.632,0,-3)
                }else{
                    pos-=0.08
                    print(pos)
                    SphereNode?.position = SCNVector3(-0.632,0,pos)
                    SphereNodeFr?.position = SCNVector3(1.67,0,self.gameConnect.frUserPos)
                    self.gameConnect.addPoint(posZ: pos)
                    UpdatePos()
                }

            }
        }
}


struct StrokeText: View {
    let text:String
    let width:CGFloat
    let borderColor:Color
    let fontColor:Color
    
    var body: some View{
        ZStack{
//            ZStack{
//                Text(text).offset(x: width, y: width)
//                Text(text).offset(x: -width, y: width)
//                Text(text).offset(x: width, y: -width)
//                Text(text).offset(x: -width, y: -width)
//            }
//            .foregroundColor(borderColor)
//            .font(.system(size:48,weight: .bold))
            Text(text)
                .foregroundColor(fontColor)
                .font(.system(size:72,weight: .bold))
        }.padding(.bottom, 200.0)
    }
}

//動畫參考
//let action = SCNAction.moveBy(x: 0, y: 0.3, z: 0, duration: 3)
//    action.timingMode = .easeInEaseOut
//    rocketshipNode.runAction(action)
