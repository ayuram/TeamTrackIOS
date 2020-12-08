//
//  EventView.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 12/5/20.
//

import SwiftUI

struct EventView: View {
    let event: Event
    var body: some View {
        TabView{
          TeamList()
            .tabItem {
                Image(systemName: "person.3.fill")
                Text("Teams")
            }
            MatchList()
            .tabItem {
                Image(systemName: "sportscourt.fill")
                Text("Matches")
            }
        }.environmentObject(event)
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(event: Event())
    }
}
