//
//  MainView.swift
//  potatosport
//
//  Created by 蔡瑀 on 2022/6/19.
//

import SceneKit
import SwiftUI


struct MainView: View {
    
    var body: some View {
        ZStack {
               Image("main_bg")
                   .resizable()
                   .scaledToFill()
                   .edgesIgnoringSafeArea(.all)
               Image("main_player")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            MainUIView()
           }
       
    }
}
struct MainUIView: View {
    var body: some View {
        HStack(alignment:.top, spacing:50) {
            VStack{
                ZStack(alignment: .center){
                    Image("main_userButton")
                    Text("user").font(.custom("Noto Sans TC Bold", size: 20)).foregroundColor(Color(#colorLiteral(red: 0.24, green: 0.2, blue: 0.3, alpha: 1))).tracking(2).fontWeight(.black).offset(x: 0, y: -3)
                }
               
                Spacer()
            }
            Spacer()
            VStack{
                Button {
                    print("button select mode")
                } label: {
                    ZStack(alignment: .center){
                        Image("main_changemode")
                        Text("選擇模式").font(.custom("Noto Sans TC Bold", size: 20)).foregroundColor(Color(#colorLiteral(red: 0.24, green: 0.2, blue: 0.3, alpha: 1))).tracking(2).fontWeight(.black)
                    }
                }
                
                
                Spacer()
            }
            Spacer()
            VStack(alignment:.trailing){
                Spacer()
                VStack(alignment:.trailing , spacing:30 ){
                    ButtonView(button: Btn(name: "建立房間", width: 112, height: 38.4,fontsize:16))
                    ButtonView(button: Btn(name: "開始遊戲", width: 174, height: 50.4,fontsize: 20))
                }
            }
        }
    }
}
struct ModelView: View{
    
    var body: some View {
        SceneView(scene: {
                           let scene = SCNScene(named: "toy_robot_vintage.usdz")!
                           scene.background.contents = UIColor.clear/// here!
                           return scene
                       }(),
                       options: [.autoenablesDefaultLighting,.allowsCameraControl]
                   )
            .frame(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height / 2)
        
    }
}

// .frame(width: 112.1, height: 38.4)
