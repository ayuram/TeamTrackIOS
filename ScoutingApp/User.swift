//
//  User.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 10/9/20.
//

import SwiftUI
import Combine
struct User: View {
    var data: Data = Data()
    @State var number: String = ""
    @State var show = false
    var body: some View {
        NavigationView{
            VStack{
                
                List{
                    NavigationLink(destination: Text("Hello World")){
                        HStack{
                            Text("Ideal Alliance")
                        }
                    }
                    TeamNav(data.user ?? Team("Null","Enter Team Name"), data)
                }
            }
            .navigationBarTitle(data.user?.name ?? "Your Team")
            .navigationBarItems(trailing: Button("Set Team"){
                show.toggle()
            }).sheet(isPresented: $show, content: {
                acsheet()
            })
            
        }
    }
    func acsheet() -> some View{
        NavigationView{
            VStack{
                TextField("Team Number", text: $number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onReceive(Just(number), perform: { newValue in
                        let filtered = newValue.filter {"0123456789".contains($0)}
                        self.number = filtered != newValue ? filtered : self.number
                    })
            }
            .navigationBarItems(trailing: Button("Save"){
                let t = Team(number, "Cuttlefish")
                data.addTeam(t)
                data.user = t
                show.toggle()
            })
        }
    }
}

struct User_Previews: PreviewProvider {
    static var previews: some View {
        User()
    }
}
