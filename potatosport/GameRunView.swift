//
//  GameRunView.swift
//  potatosport
//
//  Created by 蔡瑀 on 2022/6/22.
//

import SwiftUI
import SceneKit

var pos:Float = 0
var scanbody:Bool = false
var running:Bool = false
var startgame:Bool = false

struct GameRunView:View{
    @Binding var isPlaying:Bool
    
    @State private var GameState:Int = 0
    
    @State private var show3:Bool = true
    @State private var show2:Bool = false
    @State private var show1:Bool = false
    @State private var showstart:Bool = false
    
    //取得場景物件
    var scene = SCNScene(named: "Game.scn")
    var cameraNode:SCNNode?{
        scene?.rootNode.childNode(withName: "camera", recursively: false)
    }
    var SphereNode:SCNNode?{
        scene?.rootNode.childNode(withName: "player", recursively: false)
    }
    
    var body: some View{
        ZStack{
            if GameState == 0{
                IntroView(GameState: self.$GameState)
            }
            if GameState == 1 || GameState == 2 || GameState == 3 || GameState == 4{
                ZStack(alignment: .center){
                    RunActionView()
                    if GameState == 1{
                        Text("請讓鏡頭能夠偵測到您的全身")
                            .foregroundColor(Color("white"))
                            .fontWeight(.black)
                            .font(.system(size: 45))
                            .frame(width: 680, height: 63)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(10)
                    }
                    if GameState == 2{
                        Text("做得好！\n接著，來試試看提膝奔跑吧！")
                            .foregroundColor(Color("white"))
                            .fontWeight(.black)
                            .font(.system(size: 45))
                            .frame(width: 680, height: 126)
                            .background(Color("lightgreen").opacity(0.8))
                            .cornerRadius(10)
                    }
                    if GameState == 3{
                        Text("太棒了！比賽即將開始！")
                            .foregroundColor(Color("white"))
                            .fontWeight(.black)
                            .font(.system(size: 45))
                            .frame(width: 680, height: 63)
                            .background(Color("yellow_500").opacity(0.5))
                            .cornerRadius(10)
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline:.now()+5){
                                    GameState = 4
                                    print("switch state to \(self.GameState)")
                                }
                            }
                    }
                    if GameState == 4{
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
                                    }
                                    
                                }
                            }
                                
                        }
                        
                    }
                }
            }
            if GameState == 5{
                FinalView(isPlaying: self.$isPlaying, GameState: self.$GameState)
            }
        }.onAppear{
            self.CheckGameState()
        }
        
    }
    
    func CheckGameState(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            //print("CheckGameState")
            if scanbody == true && self.GameState == 1{
                self.GameState = 2
                print("switch state to \(self.GameState)")
            }
            if running == true && self.GameState == 2{
                self.GameState = 3
                print("switch state to \(self.GameState)")
            }
            CheckGameState()
            
        }
    }
    
    //設定初始位置
    func InitPos(){
        //print("-----> 設定初始位置")
        SphereNode?.position = SCNVector3(-0.632,0,0)
    }
    func UpdatePos() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            //print("-----> UpdatePos")
            SphereNode?.position = SCNVector3(-0.632,0,pos)
            if pos < -3 {
                self.GameState = 5
            }
            UpdatePos()
        }
    }
}

//動畫參考
//let action = SCNAction.moveBy(x: 0, y: 0.3, z: 0, duration: 3)
//    action.timingMode = .easeInEaseOut
//    rocketshipNode.runAction(action)
