//
//  EventNav.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 12/5/20.
//

import SwiftUI

struct EventNav: View {
    @EnvironmentObject var dataModel: DataModel
    let event: Event
    var body: some View {
        HStack {
            Image(systemName: "externaldrive.fill")
                .foregroundColor(Color("AccentColor"))
            Text(event.name)
                .bold()
            Spacer()
            Image(systemName: "person.3.fill")
        }.frame(height: 30, alignment: .leading)
        .navLink(AnyView(EventView(event: event).environmentObject(dataModel)))
    }
}
struct VirtualEventNav: View{
    @EnvironmentObject var dataModel: DataModel
    let event: Event
    var body: some View{
        HStack {
            Image(systemName: "externaldrive.fill")
                .foregroundColor(Color("AccentColor"))
            Text(event.name)
                .bold()
            Spacer()
            Image(systemName: "rectangle.stack.person.crop.fill")
        }.frame(height: 30, alignment: .leading)
        .navLink(EventView(event: event).environmentObject(dataModel).format())
    }
}
struct TournamentNav: View{
    @EnvironmentObject var dataModel: DataModel
    let event: Event
    var body: some View{
        HStack {
            Image(systemName: "cloud.fill")
                .foregroundColor(Color("AccentColor"))
            Divider()
            Text(event.name.capitalized)
                .bold()
            Spacer()
            Image(systemName: "person.3.fill")
        }.frame(width: 300, height: 30, alignment: .leading)
    }
}
struct EventNav_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            EventNav(event: Event()).environmentObject(DataModel())
            TournamentNav(event: Event()).environmentObject(DataModel())
        }
    }
}
