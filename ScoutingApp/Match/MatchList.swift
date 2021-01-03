//
//  MatchList.swift
//  FTCscorer
//
//  Created by Ayush Raman on 8/23/20.
//  Copyright © 2020 MSET Cuttlefish. All rights reserved.
//

import SwiftUI
import Combine

struct MatchList: View {
    @EnvironmentObject var dataModel: DataModel
    @ObservedObject var event: Event
    @State var add = false
    var team: Team? = .none

    init(_ e: Event){
        event = e
        UITableView.appearance().backgroundColor = UIColor(Color("background"))
    }
    init(team: Team, event: Event){
        self.team = team
        self.event = event
        UITableView.appearance().backgroundColor = UIColor(Color("background"))
    }
    var body: some View {
        switch team{
        case .none: return List{
            ForEach(event.matches){ match in
                matchNav(match, event)
            }
            .onDelete(perform: delete)
            .onMove(perform: { indices, newOffset in
                event.matches.move(fromOffsets: indices, toOffset: newOffset)
            })
        }.navigationBarTitle("Matches")
        .navigationBarItems(trailing: Button("Add"){
            if event.type == .virtual{
               event.addMatch(Match(team: team ?? Team("", "")))
            }
            else{
                add.toggle()
                red0 = event.teams[0].number
                red1 = event.teams[0].number
                blue0 = event.teams[0].number
                blue1 = event.teams[0].number
            }
        }.disabled(event.teams.count == 0))
        .sheet(isPresented: $add) {
            AddMatch
        }
        .frame(width: UIScreen.main.bounds.width)
        .format()
        
        default: return List{
            if event.matches.filter({$0.red.0 == team || $0.red.1 == team || $0.blue.0 == team || $0.blue.1 == team}).count != 0{
            ForEach(0...event.matches.filter({$0.red.0 == team || $0.red.1 == team || $0.blue.0 == team || $0.blue.1 == team}).count - 1, id: \.self){
                
                matchNav(event.matches.filter({$0.red.0 == team || $0.red.1 == team || $0.blue.0 == team || $0.blue.1 == team})[$0], event, index: $0)
            }
            .onDelete(perform: delete)
            .onMove(perform: { indices, newOffset in
                event.matches.move(fromOffsets: indices, toOffset: newOffset)
                dataModel.saveEvents()
            })
            }
        }.navigationBarTitle("Matches")
        .navigationBarItems(trailing: Button("Add"){
            if event.type == .virtual{
                event.addMatch(Match(team: team ?? Team("", "")))
            }
            else{
                add.toggle()
                red0 = event.teams[0].number
                red1 = event.teams[0].number
                blue0 = event.teams[0].number
                blue1 = event.teams[0].number
            }
        }.disabled(event.teams.count == 0))
        .sheet(isPresented: $add) {
            AddMatch
        }
        .frame(width: UIScreen.main.bounds.width)
        .format()
        }
        
    }
    func delete(at offsets: IndexSet){
        let matches = offsets
            .map{event.matches[$0]}
        matches
            .map{ match in
                match.red.0.scores.removeAll {$0.id == match.id}
                match.red.1.scores.removeAll {$0.id == match.id}
                match.blue.0.scores.removeAll {$0.id == match.id}
                match.blue.1.scores.removeAll {$0.id == match.id}
            }
        event.matches.remove(atOffsets: offsets)
        dataModel.saveEvents()
    }
    @State var red0: String = ""
    @State var red1: String = ""
    @State var blue0: String = ""
    @State var blue1: String = ""
    @State var next = false
    var AddMatch: some View {
        NavigationView{
            VStack{
                Picker(selection: $red0, label: Text("")){
                    ForEach(event.teams){ team in
                        Text("\(team.number) \(team.name)").tag(team.number)
                    }
                }
                Picker(selection: $red1, label: Text("")){
                    ForEach(event.teams){ team in
                        Text("\(team.number) \(team.name)").tag(team.number)
                    }
                }
            }
            .navigationBarItems(leading: Button("Cancel"){
                add.toggle()
            }, trailing: NavigationLink(destination: blue){
                Text("Next").accentColor(.red)
            })
            .navigationBarTitle("Red Alliance")
        }
    }
    var blue: some View{
        VStack{
            Picker(selection: $blue0, label: Text("")){
                ForEach(event.teams){ team in
                    Text("\(team.number) \(team.name)").tag(team.number)
                }
            }
            Picker(selection: $blue1, label: Text("")){
                ForEach(event.teams){ team in
                    Text("\(team.number) \(team.name)").tag(team.number)
                }
            }
        }
        .navigationBarItems(trailing: Button("Save"){
            let r0 = event.dictTeams()[red0] ?? Team("","")
            let r1 = event.dictTeams()[red1] ?? Team("","")
            let b0 = event.dictTeams()[blue0] ?? Team("","")
            let b1 = event.dictTeams()[blue1] ?? Team("","")
            event.addMatch(Match(red: (r0,r1), blue: (b0, b1)))
            dataModel.saveEvents()
            add.toggle()
        }.accentColor(.blue))
        .navigationBarTitle(Text("Blue Alliance"))
    }
}


struct MatchList_Previews: PreviewProvider {
    static var previews: some View {
        MatchList(Event())
            .environmentObject(DataModel())
    }
}
