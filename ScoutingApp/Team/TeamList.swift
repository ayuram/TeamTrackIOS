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
//    init(){
//        UITableView.appearance().backgroundColor = .white
//    }
    var body: some View {
        NavigationView{
            
            List{
                ForEach(data.teams){ team in
                    TeamNav(team, data)
                }
                
            }
            .navigationBarTitle("Teams")
            .navigationBarItems(trailing: Button("Add"){
                self.sheet.toggle()
            }).sheet(isPresented: $sheet){
                sht()
            }
            
        }
    }
    @State var name: (String, String) = ("", "")
    func sht() -> some View{
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
            Button("Save"){
                data.addTeam(Team(name.0, name.1))
                self.sheet = false
            }
        }
    }
}


struct TeamList_Previews: PreviewProvider {
    static var previews: some View {
        TeamList()
            
    }
}
