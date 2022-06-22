//
//  GameRunView.swift
//  potatosport
//
//  Created by 蔡瑀 on 2022/6/22.
//

import SwiftUI
import SceneKit

var pos:Float = 3


struct GameRunView:View{
    var scene = SCNScene(named: "Game.scn")
    var cameraNode:SCNNode?{
        scene?.rootNode.childNode(withName: "camera", recursively: false)
    }
    var SphereNode:SCNNode?{
        scene?.rootNode.childNode(withName: "sphere", recursively: false)
    }
    var body: some View{
        ZStack{
            SceneView(
                scene:scene,
                pointOfView:cameraNode,
                options:[.allowsCameraControl]
            )
            
        }.onAppear{
            self.InitPos()
        }
        
    }
    //設定初始位置
    func InitPos(){
        SphereNode?.position = SCNVector3(pos,pos,0)
    }
}


