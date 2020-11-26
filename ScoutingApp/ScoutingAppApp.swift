//
//  ScoutingAppApp.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 10/8/20.
//

import SwiftUI

@main
struct ScoutingAppApp: App {
    var event = Event()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(event)
        }
    }
}
struct ScoutingAppApp_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
    }
}
