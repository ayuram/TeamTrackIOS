//
//  ScoutingAppApp.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 10/8/20.
//

import SwiftUI
import UIKit
import Firebase

@main
struct ScoutingAppApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                
        }
    }
}
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
struct ScoutingAppApp_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
    }
}
