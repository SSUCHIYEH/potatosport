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
    @EnvironmentObject var musicControl: musicControl
    @EnvironmentObject var authModel: AppAuthViewModel
    
//    @Binding var isPlaying:Bool
//    @Binding var GameState:Int
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    var body: some View{
        ZStack{
            Image("final_bg")
                .resizable()
                .scaledToFill()
            HStack(){
                VStack(){
                    Spacer()
                    Image("final_loseplayer")
                        
                }
                Spacer().frame(width: 500)
            }
            .frame(width: width, height: height)
            HStack{
                HStack{}.frame(width: 200)
                Image("final_cheer")
            }
            VStack(){
                Spacer()
                Image("final_winplayer")
            }
//            .edgesIgnoringSafeArea(.bottom)
            HStack{
                VStack{
                    Image("final_title")
                    Spacer()
                    Text("fakerPlayer")
                        .foregroundColor(Color("dark")).fontWeight(.black)
                }
                Spacer()
            }.frame(width: width, height: height)
            VStack(){
                Image("final_win")
                Spacer()
                Text(self.authModel.userName)
                    .foregroundColor(Color("dark")).fontWeight(.black)
            }
            HStack{
                Spacer()
                VStack{
                    Spacer()
                    Button(action: {
                        startgame = false
                        scanbody = false
                        running = false
                        roomConnect.outRoom()
                        gameConnect.resetGameInfo()
                        pos = 0
                    }, label: {
                        BackHomeBtnView()
                    })
                   
                }
                Spacer().frame(width: 50)
            }.frame(width: width, height: height)
        }.onAppear{
            self.musicControl.win()
        }
    }
}

struct FinalView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FinalView()
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
