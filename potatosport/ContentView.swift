//
//  ContentView.swift
//  potatosport
//
//  Created by ruby0926 on 2022/6/10.
//

import SwiftUI

struct ContentView: View {
    @State var email = ""
    @State var password = ""
    
    @State private var orientation = UIDeviceOrientation.unknown
    
    @EnvironmentObject var authViewModel: AppAuthViewModel
    
//    var body: some View {
//        RunActionView()
//    }
    var body: some View {
        NavigationView{
            if authViewModel.authLoading {
                Text("連線中...")
            }else{
                if authViewModel.signedIn {
                    IndexView()
                } else {
                    SignInView()
                }
            }
            
        }.onAppear{
            authViewModel.isSignIn()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

