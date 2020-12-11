//
//  TeamList.swift
//  FTCscorer
//
//  Created by Ayush Raman on 10/4/20.
//  Copyright © 2020 MSET Cuttlefish. All rights reserved.
//

import SwiftUI
import Combine

struct TeamList: View {
    @EnvironmentObject var dataModel: DataModel
    let event: Event
    @State var sheet = false
    init(_ e : Event){
        event = e
    }
    var body: some View {
        VStack{
            List{
                ForEach(event.teams){ team in
                    TeamNav(team, event)
                }
                .onDelete(perform: { indexSet in
                    event.teams.remove(atOffsets: indexSet)
                    event.saveTeams()
                })
                .onMove(perform: move)
            }
            .listStyle(GroupedListStyle())
        }
            .navigationBarTitle("Teams")
            .navigationBarItems(trailing: Button("Add"){
                self.sheet.toggle()
            }).sheet(isPresented: $sheet){
                sht()
            }
        .frame(width: UIScreen.main.bounds.width)
        
    }
    func move(from source: IndexSet, to destination: Int){
        event.teams.move(fromOffsets: source, toOffset: destination)
        event.saveTeams()
    }
    @State var name: (String, String) = ("", "")
    func sht() -> some View{
        NavigationView{
            VStack{
                HStack {
                    TextField("Team Number", text: $name.0)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .onReceive(Just(name.0), perform: { newValue in
                            let filtered = newValue.filter {"0123456789".contains($0)}
                            self.name.0 = filtered != newValue ? filtered : self.name.0
                        })
                    TextField("Name", text: $name.1)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                }
            }
            .navigationBarTitle("Add Team")
            .navigationBarItems(leading: Button("Cancel"){
                name.0 = ""
                name.1 = ""
                self.sheet = false
            },trailing: Button("Save"){
                event.addTeam(Team(name.0, name.1))
                event.addTeam(Team(name.0, name.1))
                name.0 = ""
                name.1 = ""
                self.sheet = false
            }
            .disabled(name.0.trimmingCharacters(in: .whitespacesAndNewlines) == "" || name.1.trimmingCharacters(in: .whitespacesAndNewlines) == ""))
        }
    }
    func check(val: (String, String)) -> Bool {
        let number = val.0.trimmingCharacters(in: .whitespacesAndNewlines)
        return !event.teams.contains{$0.number == number}
    }
}


struct TeamList_Previews: PreviewProvider {
    static var previews: some View {
        TeamList(Event())
            .environmentObject(DataModel())
    }
}
