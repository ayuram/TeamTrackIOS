//
//  ScoutingAppApp.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 10/8/20.
//

import SwiftUI

@main
struct ScoutingAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any?]? = nil) -> Bool{
        return true
    }
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity?{
        return scene.userActivity
    }
    func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool{
        return true
    }
    func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool{
        return true
    }
}
struct ScoutingAppApp_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
    }
}
