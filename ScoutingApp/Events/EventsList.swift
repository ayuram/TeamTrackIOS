//
//  EventsList.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 12/5/20.
//

import SwiftUI

struct EventsList: View {
    let data: DataModel
    var body: some View {
        NavigationView{
            VStack{
                List{
                    Text("Hello World")
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
