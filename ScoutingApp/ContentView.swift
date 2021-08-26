//
//  ContentView.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 10/9/20.
//

import SwiftUI
struct ContentView: View {
    @ObservedObject var dataModel: DataModel = DataModel()
    init(){
        UITableView.appearance().backgroundColor = UIColor(Color("background"))
    }
    var body: some View {
        EventsList()
            .environmentObject(dataModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
