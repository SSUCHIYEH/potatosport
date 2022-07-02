//
//  FinalView.swift
//  potatosport
//
//  Created by 蔡瑀 on 2022/6/26.
//

import SwiftUI

struct FinalView:View{
    @EnvironmentObject var roomConnect: roomsConnetModel
    @EnvironmentObject var gameConnect: gameConnectViewModel
//    @Binding var isPlaying:Bool
//    @Binding var GameState:Int
    var body: some View{
        ZStack{
            Image("final_bg")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            HStack(){
                VStack(){
                    Spacer()
                    Image("final_loseplayer")
                }
                Spacer()
            }
            .edgesIgnoringSafeArea(.bottom)
            HStack{
                HStack{}.frame(width: 200)
                Image("final_cheer")
            }
            VStack(){
                Spacer()
                Image("final_winplayer")
            }
            .edgesIgnoringSafeArea(.bottom)
            HStack{
                VStack{
                    Image("final_title")
                    Spacer()
                    Text("空中時刻").foregroundColor(Color("dark")).fontWeight(.black)
                }
                Spacer()
            }
            VStack(){
                Image("final_win")
                Spacer()
                Text("運動小胖丁").foregroundColor(Color("dark")).fontWeight(.black)
                
            }
            HStack{
                Spacer()
                VStack{
                    Spacer()
                    Button(action: {
                        startgame = false
                        scanbody = false
                        running = false
                        roomConnect.isPlaying = false
                        gameConnect.gameState = 0
                        pos = 0
                    }, label: {
                        BackHomeBtnView()
                    })
                }
            }
        }
    }
}
