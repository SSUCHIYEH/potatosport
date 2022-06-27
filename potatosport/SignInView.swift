//
//  SignInView.swift
//  potatosport
//
//  Created by ruby0926 on 2022/6/21.
//

import SwiftUI
import Foundation

// 登入
struct SignInView: View {
    @State var email = ""
    @State var password = ""
    
    @State private var orientation = UIDeviceOrientation.unknown
    
    @EnvironmentObject var viewModel:AppAuthViewModel
    
    var body: some View {
        NavigationView{
            VStack {
                TextField("帳號",text:$email).padding().border(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).cornerRadius(/*@START_MENU_TOKEN@*/8.0/*@END_MENU_TOKEN@*/)
                SecureField("密碼",text:$password).padding().border(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).cornerRadius(/*@START_MENU_TOKEN@*/8.0/*@END_MENU_TOKEN@*/)
                Button(action: {
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    viewModel.signIn(email: email, password: password)
                    
                },label:{
                    Text("登入")
                        .foregroundColor(Color.white)
                        .frame(width:200, height:50)
                        .background(Color.blue).cornerRadius(8)
                })
            }.padding()
        }
        .padding(.horizontal, 20.0)
    }
}
