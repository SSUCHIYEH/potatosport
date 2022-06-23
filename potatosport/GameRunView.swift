//
//  GameRunView.swift
//  potatosport
//
//  Created by 蔡瑀 on 2022/6/22.
//

import SwiftUI
import SceneKit

var pos:Float = 0


struct GameRunView:View{
    var scene = SCNScene(named: "Game.scn")
    var cameraNode:SCNNode?{
        scene?.rootNode.childNode(withName: "camera", recursively: false)
    }
    var SphereNode:SCNNode?{
        scene?.rootNode.childNode(withName: "player", recursively: false)
    }
    
    var body: some View{
        ZStack{
            RunActionView()
            SceneView(
                scene:scene,
                pointOfView:cameraNode,
                options:[.allowsCameraControl]
            ).frame(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
            
            
        }.onAppear{
            self.InitPos()
            self.UpdatePos()
        }
        
    }
    //設定初始位置
    func InitPos(){
        SphereNode?.position = SCNVector3(0,0,0)
    }
    func UpdatePos() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            //print("-----> callFunc")
            SphereNode?.position = SCNVector3(0,0,pos)
            UpdatePos()
        }
    }
}

//動畫參考
//let action = SCNAction.moveBy(x: 0, y: 0.3, z: 0, duration: 3)
//    action.timingMode = .easeInEaseOut
//    rocketshipNode.runAction(action)
