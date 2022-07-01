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
    @EnvironmentObject var rooomConnectModel: roomsConnetModel
    var body: some View {
        VStack{
            if authViewModel.authLoading {
               Text("連線中...")
           }else{
               if authViewModel.signedIn {
                   if rooomConnectModel.isPlaying{
                       Text("開始偵測身體")
//                       GameRunView()
                      //
                   }else{
                       //RunActionView()
                       MainView()
                       .onAppear{
                           UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue,forKey: "orientation")
                           AppDelegate.orientationLock = .landscapeRight
                       }
                       .onDisappear{
                           AppDelegate.orientationLock = .all
                       }
                   }
               } else {
                   SignInView()
               }
           }
        }
        .padding(0)
        .onAppear{
            authViewModel.isSignIn()
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
     
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

