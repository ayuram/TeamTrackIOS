//
//  TeamNav.swift
//  FTCscorer
//
//  Created by Ayush Raman on 10/4/20.
//  Copyright © 2020 MSET Cuttlefish. All rights reserved.
//

import SwiftUI

struct TeamNav: View {
    @EnvironmentObject var dataModel: DataModel
    var team: Team
    var data: Event
    init(_ t: Team, _ d: Event){
        team = t
        data = d
    }
    var body: some View {
        NavigationLink(destination: TeamView(team: team, event: data).environmentObject(dataModel)){
        HStack{
            Text("\(team.number)".replacingOccurrences(of: ",", with: ""))
                .bold()
            Text(team.name.capitalized)
                .italic()
            Spacer()
        }
        }.background(Color.clear)
    }
}

struct TeamNav_Previews: PreviewProvider {
    static var previews: some View {
        TeamNav(Team("6165", "Cuttlefish"), Event())
    }
}
