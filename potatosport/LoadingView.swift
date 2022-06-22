//
//  LoadingView.swift
//  potatosport
//
//  Created by 蔡瑀 on 2022/6/21.
//

import SwiftUI

struct LoadingView : View{
    var body: some View{
        ZStack{
            Rectangle()
                .fill(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4)))
                .edgesIgnoringSafeArea(.all)
            Image("loading")
        }
    }
}
