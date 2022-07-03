//
//  SelectModeView.swift
//  potatosport
//
//  Created by 蔡瑀 on 2022/6/22.
//

import SwiftUI
struct SelectmodeView: View {
    @Binding var showSelectmodeView:Bool
    @EnvironmentObject var roomConnectViewModel:roomsConnetModel
    @EnvironmentObject var musicControl:musicControl
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4)))
                .edgesIgnoringSafeArea(.all)
            ZStack{
                Image("select_modal")
                    .frame(width:512)
                    //.resizable()
                    .scaledToFill()
                    //.edgesIgnoringSafeArea(.all)
                HStack{
                    HStack{}.frame(width:64)
                    VStack(alignment: .leading, spacing: 30){
                        HStack{
                            Text("選擇遊戲模式").foregroundColor(Color("dark")).tracking(1.8)
                            Spacer()
                            Button(action: {
                                self.showSelectmodeView = false
                            }, label: {
                                Image("icon_close")
                            })
                        }.frame(width:512)
                        HStack(spacing:20){
                            Button(action: {
                                self.roomConnectViewModel.mode = "mode1"
                                print(self.roomConnectViewModel.mode)
                                self.musicControl.btnClickPlay()
                            }, label: {
                                ButtonView(button: Btn(name: "吃雞", width: 78, height: 40,fontsize:16))
                            })
                            Button(action: {
//                                self.roomConnectViewModel.mode = "mode2"
//                                print(self.roomConnectViewModel.mode)
                                self.musicControl.btnClickPlay()
                            }, label: {
                                ButtonView(button: Btn(name: "對戰", width: 78, height: 40,fontsize:16))
                            })
                            
                            Button(action: {
                                self.musicControl.btnClickPlay()
                            }, label: {
                                ButtonView(button: Btn(name: "合作", width: 78, height: 40,fontsize:16))
                            })
                            
                        }
                        HStack{
                            Text("希望鍛鍊的部位").foregroundColor(Color("dark")).tracking(1.8)
                            
                        }
                        HStack(spacing:20){
                            Button(action: {
                            }, label: {
                                ButtonView(button: Btn(name: "手臂", width: 78, height: 40,fontsize:16))
                            })
                            Button(action: {
                            }, label: {
                                ButtonView(button: Btn(name: "腹部", width: 78, height: 40,fontsize:16))
                            })
                            Button(action: {
                            }, label: {
                                ButtonView(button: Btn(name: "腿部", width: 78, height: 40,fontsize:16))
                            })
                            Button(action: {
                            }, label: {
                                ButtonView(button: Btn(name: "臀部", width: 78, height: 40,fontsize:16))
                            })
                            Button(action: {
                            }, label: {
                                ButtonView(button: Btn(name: "全身", width: 78, height: 40,fontsize:16))
                            })
                            
                        }
                    }
                }
            }
            
            
            
        }//.frame(width:UIScreen.main.bounds.width-36,height:UIScreen.main.bounds.height-12)
        
    }
    
}
