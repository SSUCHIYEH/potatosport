//
//  potatosportApp.swift
//  potatosport
//
//  Created by ruby0926 on 2022/6/10.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct potatosportApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var AppDelegate
    var body: some Scene {
        WindowGroup {
            let viewModel = AppAuthViewModel()
            ContentView().environmentObject(viewModel)
            
        }
    }
}
