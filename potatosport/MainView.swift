//
//  MainView.swift
//  potatosport
//
//  Created by 蔡瑀 on 2022/6/19.
//

import SceneKit
import SwiftUI


struct MainView: View {
    @Binding var isPlaying:Bool
    
    @State private var showAddFriendView = false
    @State private var showSelectmodeView = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            Image("main_bg")
                .frame(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
                //.frame(width: 896, height: 414)
                //.resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            Image("main_player")
                .frame(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
               // .frame(width: 896, height: 414)
                //.resizable()
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
                Spacer()
            }
            .frame(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
            
                
            MainUIView(showSelectmodeView:self.$showSelectmodeView, isPlaying: self.$isPlaying)
            
            
            
            if self.showAddFriendView{
                AddFriendView(showAddFriendView: self.$showAddFriendView)
            }
            if self.showSelectmodeView{
                SelectmodeView(showSelectmodeView:self.$showSelectmodeView)
            }
           // LoadingView()
            
            
        }
       // .frame(width:UIScreen.main.bounds.width-36,height:UIScreen.main.bounds.height-12)
       
        
    }
}
struct MainUIView: View {
    @Binding var showSelectmodeView:Bool
    @Binding var isPlaying:Bool
    var body: some View {
        HStack(alignment:.top, spacing:50){
            VStack{
                HStack{}.frame(height:3)
                ZStack(alignment: .center){
                    Image("main_userButton")
                    Text("user").foregroundColor(Color("dark")).tracking(2).fontWeight(.regular).offset(x: 0, y: -3)
                }
               
                Spacer()
            }
            Spacer()
            VStack{
                HStack{}.frame(height:3)
                Button(action: {
                   // print("open selectmode button")
                    self.showSelectmodeView = true
                }, label: {
                    ZStack(alignment: .center){
                        Image("main_changemode")
                        Text("選擇模式").foregroundColor(Color("dark")).tracking(2).fontWeight(.black)
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
                        HStack{
                            ButtonView(button: Btn(name: "建立房間", width: 112, height: 38.4,fontsize:14))
                            HStack{}.frame(width:6)
                        }
                        
                    })
                    Button(action: {
                        self.isPlaying=true
                    }, label: {
                        HStack{
                            ButtonView(button: Btn(name: "開始遊戲", width: 174, height: 50.4,fontsize: 20))
                            HStack{}.frame(width:6)
                        }
                    })
                    HStack{}.frame(height:6)
                }
            }
        }
        .frame(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
        //.frame(width: 860, height: 402)
        
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
