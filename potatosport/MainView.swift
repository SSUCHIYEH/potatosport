//
//  MainView.swift
//  potatosport
//
//  Created by 蔡瑀 on 2022/6/19.
//

import SceneKit
import SwiftUI


struct MainView: View {
    @State private var showAddFriendView = false
    @State private var showSelectmodeView = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            Image("main_bg")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            Image("main_player")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            HStack{
                HStack{}.frame(width:24)
                Button(action: {
                   // print("click addfriend button")
                    self.showAddFriendView = true
                }, label: {
                    
                    AddFriendBtnView()
                })
            }
                
            
            MainUIView(showSelectmodeView:self.$showSelectmodeView)
            if self.showAddFriendView{
                AddFriendView(showAddFriendView: self.$showAddFriendView)
            }
            if self.showSelectmodeView{
                SelectmodeView(showSelectmodeView:self.$showSelectmodeView)
            }
            
            
        }
        
    }
}
struct MainUIView: View {
    @Binding var showSelectmodeView:Bool
    var body: some View {
        HStack(alignment:.top, spacing:50) {
            VStack{
                ZStack(alignment: .center){
                    Image("main_userButton")
                    Text("user").font(.custom("Noto Sans TC Bold", size: 20)).foregroundColor(Color("dark")).tracking(2).fontWeight(.black).offset(x: 0, y: -3)
                }
               
                Spacer()
            }
            Spacer()
            VStack{
                Button(action: {
                   // print("open selectmode button")
                    self.showSelectmodeView = true
                }, label: {
                    ZStack(alignment: .center){
                        Image("main_changemode")
                        Text("選擇模式").font(.custom("Noto Sans TC Bold", size: 20)).foregroundColor(Color("dark")).tracking(2).fontWeight(.black)
                    }
                })
                Spacer()
            }
            Spacer()
            VStack(alignment:.trailing){
                Spacer()
                VStack(alignment:.trailing , spacing:30 ){
                    Button(action: {
                        
                    }, label: {
                        ButtonView(button: Btn(name: "建立房間", width: 112, height: 38.4,fontsize:16))
                    })
                    Button(action: {
                        
                    }, label: {
                        ButtonView(button: Btn(name: "開始遊戲", width: 174, height: 50.4,fontsize: 20))
                    })
                    
                }
            }
        }
    }
}

struct SelectmodeView: View {
    @Binding var showSelectmodeView:Bool
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4)))
                .edgesIgnoringSafeArea(.all)
            ZStack{
                Image("select_modal")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                HStack{
                    HStack{}.frame(width:64)
                    VStack(alignment: .leading, spacing: 30){
                        HStack{
                            Text("選擇遊戲模式").font(.custom("Noto Sans TC Bold", size: 18)).foregroundColor(Color("dark")).tracking(1.8)
                            Spacer()
                            Button(action: {
                                self.showSelectmodeView = false
                            }, label: {
                                Image("icon_close")
                            })
                        }.frame(width:512)
                        HStack(spacing:20){
                            Button(action: {
                            }, label: {
                                ButtonView(button: Btn(name: "對戰", width: 78, height: 40,fontsize:16))
                            })
                            Button(action: {
                            }, label: {
                                ButtonView(button: Btn(name: "吃雞", width: 78, height: 40,fontsize:16))
                            })
                            Button(action: {
                            }, label: {
                                ButtonView(button: Btn(name: "合作", width: 78, height: 40,fontsize:16))
                            })
                            
                        }
                        HStack{
                            Text("希望鍛鍊的部位").font(.custom("Noto Sans TC Bold", size: 18)).foregroundColor(Color("dark")).tracking(1.8)
                            
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
//.frame(maxWidth: .infinity, maxHeight: .infinity)
