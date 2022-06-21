//
//  Components.swift
//  potatosport
//
//  Created by 蔡瑀 on 2022/6/21.
//

import SwiftUI


//main Button
struct Btn{
    let name:String
    let width:CGFloat?
    let height:CGFloat?
    let fontsize:CGFloat
}
struct ButtonView: View{
    let button : Btn
    var body: some View {
        VStack{
            ZStack(alignment: .center){
                //陰影
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color("dark"))
                    .frame(width:button.width, height: button.height)
                    .offset(x: 5, y: 5)
                ZStack(alignment: .center){
                    //黃色button
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color("yellow_main"))
                        RoundedRectangle(cornerRadius: 5)
                            .strokeBorder(Color("white"), lineWidth: 4)
                    }
                    .frame(width: button.width, height: button.height)
                    //文字
                    Text(button.name).font(.custom("Noto Sans TC Bold", size: button.fontsize)).foregroundColor(Color("dark")).tracking(2).fontWeight(.black)
                }
            }
            
        }
    }
}
struct AddFriendBtnView: View{
    var body: some View {
        VStack{
            ZStack(alignment: .center){
                //陰影
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color("dark"))
                    .frame(width:49, height: 49)
                    .offset(x: 5, y: 5)
                ZStack(alignment: .center){
                    //黃色button
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color("yellow_main"))
                        RoundedRectangle(cornerRadius: 30)
                            .strokeBorder(Color("white"), lineWidth: 4)
                    }
                    .frame(width: 49, height: 49)
                    //文字
                    Text("+").font(.custom("Noto Sans TC Bold", size: 20)).foregroundColor(Color("dark")).tracking(2).fontWeight(.black)
                }
            }
            
        }
    }
}
