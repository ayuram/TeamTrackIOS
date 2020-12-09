//
//  EventNav.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 12/5/20.
//

import SwiftUI

struct EventNav: View {
    let event: Event
    var body: some View {
        HStack {
            Image(systemName: "externaldrive.fill.badge.plus")
                .foregroundColor(Color("AccentColor"))
            Text(event.name)
                .bold()
            Spacer()
            Image(systemName: "person.3.fill")
        }.frame(width: 300, height: 30, alignment: .leading)
        .navLink(AnyView(EventView(event: event)))
    }
}
struct VirtualEventNav: View{
    let event: VirtualEvent
    var body: some View{
        HStack {
            Image(systemName: "externaldrive.fill.badge.plus")
                .foregroundColor(Color("AccentColor"))
            Text("Some STUFF")
            Spacer()
            Image(systemName: "person.3.fill")
        }.frame(width: 300, height: 30, alignment: .leading)
    }
}
struct TournamentNav: View{
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
            EventNav(event: Event())
            TournamentNav(event: Event())
        }
    }
}
