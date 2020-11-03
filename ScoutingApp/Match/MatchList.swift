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
    @EnvironmentObject var data: Data
    @State var add = false
    init(){
        UITableView.appearance().backgroundColor = .white
    }
    var body: some View {
        NavigationView{
            List{
                ForEach(data.matches){ match in
                    matchNav(match)
                }
                .onDelete(perform: delete)
            }.navigationBarTitle("Matches")
                .navigationBarItems(trailing: Button("Add"){
                    add.toggle()
                    red0 = data.teams[0].number
                    red1 = data.teams[0].number
                    blue0 = data.teams[0].number
                    blue1 = data.teams[0].number
                }).sheet(isPresented: $add) {
                    AddMatch
            }
            .disabled(data.teams.count == 0)
            
        }
    }
    func delete(at offsets: IndexSet){
        let matches = offsets
            .map{data.matches[$0]}
        matches
            .map{ match in
                match.red.0.scores.removeAll {$0.id == match.id}
                match.red.1.scores.removeAll {$0.id == match.id}
                match.blue.0.scores.removeAll {$0.id == match.id}
                match.blue.1.scores.removeAll {$0.id == match.id}
            }
        data.matches.remove(atOffsets: offsets)
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
                                ForEach(data.teams){ team in
                                    Text("\(team.number) \(team.name)").tag(team.number)
                                }
                        }
                            Picker(selection: $red1, label: Text("")){
                                ForEach(data.teams){ team in
                                    Text("\(team.number) \(team.name)").tag(team.number)
                                }
                            }
                    }
                .navigationBarItems(trailing: NavigationLink(destination: blue){
                    Text("Next").accentColor(.red)
                        
                })
                    .navigationBarTitle("Red Alliance")
            }
        
    }
    var blue: some View{
        
            VStack{
                Picker(selection: $blue0, label: Text("")){
                    ForEach(data.teams){ team in
                        Text("\(team.number) \(team.name)").tag(team.number)
                    }
                }
                Picker(selection: $blue1, label: Text("")){
                    ForEach(data.teams){ team in
                        Text("\(team.number) \(team.name)").tag(team.number)
                            
                    }
                }
            }
        .navigationBarItems(trailing: Button("Add"){
            var r0 = data.dictTeams()[red0] ?? Team("","")
            var r1 = data.dictTeams()[red1] ?? Team("","")
            var b0 = data.dictTeams()[blue0] ?? Team("","")
            var b1 = data.dictTeams()[blue1] ?? Team("","")
            data.addMatch(Match(red: (r0,r1), blue: (b0, b1)))
            self.add.toggle()
        })
        .navigationBarTitle(Text("Blue Alliance"))
        .accentColor(.red)
       
    }
}


struct MatchList_Previews: PreviewProvider {
    static var previews: some View {
        MatchList().environmentObject(Data())
    }
}

