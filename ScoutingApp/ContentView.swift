//
//  ContentView.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 10/9/20.
//

import SwiftUI
import SwiftUICharts
struct ContentView: View {
    var data: Event //= Data(teams: UserDefaults.standard.object(forKey: "Teams") as? [Team] ?? [Team](), matches: UserDefaults.standard.object(forKey: "Matches") as? [Match] ?? [Match]())
    init(){
        UITableView.appearance().backgroundColor = UIColor(Color("background"))
//        data.addTeam(Team("7390", "Jellyfish"))
//        data.addTeam(Team("1", "Alphas"))
//        data.addTeam(Team("6165", "Cuttlefish"))
//        data.addTeam(Team("2", "Bettas"))
//        data.addTeam(Team("12", "Alzing"))
        data = Event()
        if let savedTeams = UserDefaults.standard.object(forKey: "Teams") as? Data {
            let decoder = JSONDecoder()
            if let loadedTeams = try? decoder.decode(Team.self, from: savedTeams){
                data = Event(teams: [loadedTeams], matches: UserDefaults.standard.object(forKey: "Matches") as? [Match] ?? [Match]())
                print("wow")
            }
        }
    }
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
        }.environmentObject(data)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
