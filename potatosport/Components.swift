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
                    .fill(Color(#colorLiteral(red: 0.30588236451148987, green: 0.26274511218070984, blue: 0.38823530077934265, alpha: 1)))
                    .frame(width:button.width, height: button.height)
                    .offset(x: 5, y: 5)
                ZStack(alignment: .center){
                    //黃色button
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color(#colorLiteral(red: 1, green: 0.940000057220459, blue: 0.3999999761581421, alpha: 1)))
                        RoundedRectangle(cornerRadius: 5)
                            .strokeBorder(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), lineWidth: 4)
                    }
                    .frame(width: button.width, height: button.height)
                    //文字
                    Text(button.name).font(.custom("Noto Sans TC Bold", size: button.fontsize)).foregroundColor(Color(#colorLiteral(red: 0.24, green: 0.2, blue: 0.3, alpha: 1))).tracking(2).fontWeight(.black)
                }
            }
            
        }
    }
}
