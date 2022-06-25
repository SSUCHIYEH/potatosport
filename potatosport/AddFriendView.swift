//
//  AddFriendView.swift
//  potatosport
//
//  Created by 蔡瑀 on 2022/6/21.
//

import SwiftUI

struct FriendName {
    let name:String
}
struct AddFriendView: View {
    @Binding var showAddFriendView:Bool
    let friends=[
        FriendName(name: "friend1"),
        FriendName(name: "friend2"),
        FriendName(name: "friend3")
    ]

    var body: some View {
        ZStack(alignment: .leading){
            Rectangle()
                .fill(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4)))
                .edgesIgnoringSafeArea(.all)
            ZStack(alignment:.top){
                ZStack(alignment: .bottom){
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("yellow_300"))
                        .frame(width: 281, height: 394)
                        .offset(x: 20, y: 10)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("white"))
                        .frame(width: 281, height: 348)
                        .offset(x: 20, y: 10)
                }
                VStack{
                    HStack{}.frame(width: 256, height: 6)
                    HStack{
                        Text("邀請好友").font(.custom("Noto Sans TC Bold", size: 18)).foregroundColor(Color("dark")).tracking(1.8)
                        Spacer()
                        Button(action:{
                            self.showAddFriendView = false
                        },label: {
                            Image("icon_close")
                        })
                        
                        
                    }
                    HStack{}.frame(width: 256, height: 12)
                    ForEach(0..<friends.count){item in
                        FriendRow(friend:friends[item])
                        HStack{}.frame(width: 256, height: 6)
                    }
                    Spacer()
                }
                .frame(width: 256, height: 370)
                .offset(x: 20, y: 10)
                
            }
        }
        .frame(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
    }
    
}
struct FriendRow:View{
    let friend:FriendName
    var body: some View {
        HStack{
            Circle()
                .fill(Color("lightgreen"))
                .frame(width: 8, height: 8)
            Image("icon_user")
            Text(friend.name).font(.custom("Noto Sans TC Bold", size: 14)).foregroundColor(Color("dark")).tracking(1.8)
            Spacer()
            Button(action: {
                print("邀請\(friend.name)")
            }, label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color("red"))
                        .frame(width: 46, height: 36)
                    Text("邀請")
                        .foregroundColor(Color("white"))
                }
            })
        }
    }
}
