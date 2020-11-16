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
    @EnvironmentObject var data: Data
    @State var sheet = false
    var body: some View {
        NavigationView{
            List{
                ForEach(data.teams){ team in
                    TeamNav(team, data)
                }
                .onDelete(perform: { indexSet in
                    data.teams.remove(atOffsets: indexSet)
                })
                .onMove(perform: move)
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Teams")
            .navigationBarItems(leading: EditButton().disabled(data.teams.count == 0), trailing: Button("Add"){
                self.sheet.toggle()
            }).sheet(isPresented: $sheet){
                sht()
            }
        }
    }
    func move(from source: IndexSet, to destination: Int){
        data.teams.move(fromOffsets: source, toOffset: destination)
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
                data.addTeam(Team(name.0, name.1))
                data.addTeam(Team(name.0, name.1))
                name.0 = ""
                name.1 = ""
                self.sheet = false
            }
            .disabled(name.0.trimmingCharacters(in: .whitespacesAndNewlines) == "" || name.1.trimmingCharacters(in: .whitespacesAndNewlines) == ""))
        }
    }
    func check(val: (String, String)) -> Bool {
        let number = val.0.trimmingCharacters(in: .whitespacesAndNewlines)
        return !data.teams.contains{$0.number == number}
    }
}


struct TeamList_Previews: PreviewProvider {
    static var previews: some View {
        TeamList()
            .environmentObject(Data())
    }
}
