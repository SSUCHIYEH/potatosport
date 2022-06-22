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
    
    @EnvironmentObject var viewModel: AppAuthViewModel
    
//    var body: some View {
//        RunActionView()
//    }
    var body: some View {
        NavigationView{
            if viewModel.signedIn {
                IndexView()
            } else {
                SignInView()
            }
        }.onAppear{
            viewModel.signedIn = viewModel.isSignIn
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

