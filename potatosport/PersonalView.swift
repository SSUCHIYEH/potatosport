//
//  PersonalView.swift
//  potatosport
//
//  Created by ruby0926 on 2022/7/3.
//

import Foundation
import SwiftUI



struct PersonalView:View{
    @Binding var showBackBtn:Bool
    
    var body: some View{
        ZStack{
            Image("personal_bg")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            Image("personal_content")
                .resizable()
                .frame(width: 550, height: 320)
            HStack(alignment:.top){
                Button(action: {
                    self.showBackBtn = false
                }, label: {
                    Image("back_btn")
                        .resizable()
                        .frame(width: 55, height: 55)
                })
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 200, trailing: 600))
            
        }
    }
}


//struct Personal_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            PersonalView()
//                .previewInterfaceOrientation(.landscapeLeft)
//        }
//    }
//}

//struct Personal_Previews: PreviewProvider {
//    static var previews: some View {
//        PersonalView()
////            .previewInterfaceOrientation(.landscapeLeft)
//    }
//}
