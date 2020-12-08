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
            
        }
    }
}

struct EventsList_Previews: PreviewProvider {
    static var previews: some View {
        EventsList()
    }
}
