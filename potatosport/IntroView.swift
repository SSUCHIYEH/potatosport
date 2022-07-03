//
//  IntroView.swift
//  potatosport
//
//  Created by 蔡瑀 on 2022/6/25.
//

import SwiftUI

struct IntroView:View{
    @EnvironmentObject var roomConnect: roomsConnetModel
    @EnvironmentObject var gameConnect : gameConnectViewModel
//    @Binding var GameState:Int
    var body: some View{
        ZStack(alignment: .center){
            Image("intro_bg")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            ZStack(alignment:.bottom){
                if roomConnect.mode == "mode1"{
                    Image("intro_content")
                        .resizable()
                        .frame(width: 598, height:323 )
                }
                else{
                    Image("masonIntro")
                        .resizable()
                        .frame(width: 598, height:323 )
                }
                Button(action: {
                    self.gameConnect.gameState = 1
                }, label: {
                    HStack{
                        ButtonView(button: Btn(name: "知道了", width: 128, height: 55,fontsize:20))
                        HStack{}.frame(width:6)
                    }
                    
                })
            }
        }
    }
}
