//
//  ContentView.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 10/9/20.
//

import SwiftUI

struct ContentView: View {
    var data: Data = Data()
    init(){
        UITableView.appearance().backgroundColor = UIColor(Color("background"))
        data.addTeam(Team("7390", "Jellyfish"))
        data.addTeam(Team("1", "Alphas"))
        data.addTeam(Team("6165", "Cuttlefish"))
        data.addTeam(Team("2", "Bettas"))
        data.addTeam(Team("12", "Alzing"))
    }
    var body: some View {
//        TabView{
//          TeamList()
//            .tabItem {
//                Image(systemName: "person.3.fill")
//                Text("Teams")
//            }
//            MatchList()
//            .tabItem {
//                Image(systemName: "sportscourt.fill")
//                Text("Matches")
//            }
//        }.environmentObject(data)
        SwiftUIView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
