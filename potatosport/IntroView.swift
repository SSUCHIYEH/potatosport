//
//  IntroView.swift
//  potatosport
//
//  Created by 蔡瑀 on 2022/6/25.
//

import SwiftUI

struct IntroView:View{
    @Binding var GameState:Int
    var body: some View{
        ZStack(alignment: .center){
            Image("intro_bg")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            ZStack(alignment:.bottom){
                Image("intro_content")
                    .resizable()
                    .frame(width: 598, height:323 )
                Button(action: {
                    self.GameState = 1
                    print(GameState)
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
