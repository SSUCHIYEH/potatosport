import SwiftUI
import SceneKit

struct GameRunTestView:View{

    @EnvironmentObject var musicControl: musicControl
    @EnvironmentObject var roomConnect: roomsConnetModel
    @EnvironmentObject var gameConnect:gameConnectViewModel
    @State private var show3:Bool = true
    @State private var show2:Bool = false
    @State private var show1:Bool = false
    @State private var showstart:Bool = false
    @State private var finish = false
    
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
            if gameConnect.gameState == 0{
                IntroView()
            }
            if gameConnect.gameState == 1 || gameConnect.gameState == 2 || gameConnect.gameState == 3 || gameConnect.gameState == 4{
                ZStack(alignment: .center){
                    RunActionView()
                    if gameConnect.gameState == 1{
                        Text("請讓鏡頭能夠偵測到您的全身")
                            .foregroundColor(Color("white"))
                            .fontWeight(.black)
                            .font(.system(size: 45))
                            .frame(width: 680, height: 63)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(10)
                    }
                    if gameConnect.gameState == 2{
                        Text("做得好！\n接著，來試試看提膝奔跑吧！")
                            .foregroundColor(Color("white"))
                            .fontWeight(.black)
                            .font(.system(size: 45))
                            .frame(width: 680, height: 126)
                            .background(Color("lightgreen").opacity(0.8))
                            .cornerRadius(10)
                    }
                    if gameConnect.gameState == 3{
                        Text("太棒了！比賽即將開始！")
                            .foregroundColor(Color("white"))
                            .fontWeight(.black)
                            .font(.system(size: 45))
                            .frame(width: 680, height: 63)
                            .background(Color("yellow_500").opacity(0.5))
                            .cornerRadius(10)
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline:.now()+5){
                                    gameConnect.gameState = 4
                                    print("switch state to \(self.gameConnect.gameState)")
                                }
                            }
                    }
                    if gameConnect.gameState == 4{
                        ZStack{
                            SceneView(
                                scene:scene,
                                pointOfView:cameraNode,
                                options:[.allowsCameraControl]
                            ).frame(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
                            if self.show3{
                                Image("game_3")
                                    .onAppear{
                                    self.musicControl.count()
                                    DispatchQueue.main.asyncAfter(deadline:.now()+1){
                                        self.show3 = false
                                        self.show2 = true
                                    }
                                    
                                }
                            }
                            if self.show2{
                                Image("game_2")
                                .onAppear{
                                    self.musicControl.count()
                                    DispatchQueue.main.asyncAfter(deadline:.now()+1){
                                        self.show2 = false
                                        self.show1 = true
                                    }
                                    
                                }
                            }
                            if self.show1{
                                Image("game_1")
                                .onAppear{
                                    self.musicControl.count()
                                    DispatchQueue.main.asyncAfter(deadline:.now()+1){
                                        self.show1 = false
                                        self.showstart = true
                                    }
                                    
                                }
                            }
                            if self.showstart{
                                Image("game_start")
                                .onAppear{
                                    self.musicControl.start()
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
                }
            }
            if gameConnect.gameState == 5{
                FinalView()
            }
        }.onAppear{
            self.CheckGameState()
            musicControl.mainbg.pause()
        }
        
    }
    
    func CheckGameState(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            //print("CheckGameState")
            if scanbody == true && self.gameConnect.gameState == 1{
                self.gameConnect.gameState = 2
                print("switch state to \(self.gameConnect.gameState)")
            }
            if running == true && self.gameConnect.gameState == 2{
                self.gameConnect.gameState = 3
                print("switch state to \(self.gameConnect.gameState)")
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
                self.finish = true
//                self.gameConnect.gameState = 5
            }else {
                UpdatePos()
            }
        }
    }
}

//動畫參考
//let action = SCNAction.moveBy(x: 0, y: 0.3, z: 0, duration: 3)
//    action.timingMode = .easeInEaseOut
//    rocketshipNode.runAction(action)
