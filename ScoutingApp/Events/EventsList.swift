//
//  EventsList.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 12/5/20.
//

import SwiftUI

struct EventsList: View {
    let data: DataModel
    @State var bool = false
    init(){
        data = DataModel()
        data.localEvents.append(Event())
        UITableView.appearance().backgroundColor = UIColor(Color("background"))
    }
    var body: some View {
        NavigationView{
            VStack{
                List{
                    Section(header: Text("Local Scrimmages")){
                        ForEach(data.localEvents){ event in
                            EventNav(event: event)
                        }
                    }
                    Section(header: Text("Virtual Tournaments")){

                    }
                }
            }
            .navigationBarTitle("Events")
            .navigationBarItems(trailing: Button("Add"){
                
            })

        }
//        ZStack{
//            Color.blue
//                .ignoresSafeArea(.container, edges: .all)
//            Text("Wow")
//            VStack{
//                Spacer()
//                HStack{
//                Text("Teams")
//                    .cardView()
//                    .frame(width: 100, height: 100)
//                Text("Matches")
//                    .cardView()
//                }
//            }
//        }
    }
}

struct EventsList_Previews: PreviewProvider {
    static var previews: some View {
        EventsList()
    }
}
