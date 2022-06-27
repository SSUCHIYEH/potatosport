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
    @State private var isPlaying = false
    @EnvironmentObject var authViewModel: AppAuthViewModel
    
    var body: some View {
        
        if isPlaying{
            GameRunView()
           //
        }else{
            //RunActionView()
            MainView(isPlaying: self.$isPlaying)
                .onAppear{
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue,forKey: "orientation")
                    AppDelegate.orientationLock = .landscapeRight
                }
                .onDisappear{
                    AppDelegate.orientationLock = .all
                }
        }
    }

        //        NavigationView{
        //            if authViewModel.authLoading {
        //                Text("連線中...")
        //            }else{
        //                if authViewModel.signedIn {
        //                    IndexView()
        //                } else {
        //                    SignInView()
        //                }
        //            }
        //
        //        }
        //        .onAppear{
        //            authViewModel.isSignIn()
        //        }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

