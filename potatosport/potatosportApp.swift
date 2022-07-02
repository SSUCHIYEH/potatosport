//
//  potatosportApp.swift
//  potatosport
//
//  Created by ruby0926 on 2022/6/10.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate{
    static var orientationLock = UIInterfaceOrientationMask.landscapeRight
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    func application(_ application: UIApplication,supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
}


//class AppDelegate: NSObject, UIApplicationDelegate {
//  static var orientationLock = UIInterfaceOrientationMask.landscapeRight
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//    return true
//  }
//}

@main
struct potatosportApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            let roomConnectViewModel = roomsConnetModel()
            let friendConnectViewModel = friendCoonectViewModel()
            let viewModel = AppAuthViewModel()
            let sheetModel = GlobalSheet()
            let playerControl = musicControl()
            let gameConnect = gameConnectViewModel()
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(roomConnectViewModel)
                .environmentObject(friendConnectViewModel)
                .environmentObject(sheetModel)
                .environmentObject(playerControl)
                .environmentObject(gameConnect)
            
        }
    }
}

