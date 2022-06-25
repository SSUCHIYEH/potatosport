//
//  potatosportApp.swift
//  potatosport
//
//  Created by ruby0926 on 2022/6/10.
//

import SwiftUI

@main
struct potatosportApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
class AppDelegate:NSObject,UIApplicationDelegate{
    static var orientationLock = UIInterfaceOrientationMask.landscapeRight
    func application(_ application: UIApplication,supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
