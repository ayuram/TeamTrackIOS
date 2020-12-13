//
//  matchNav.swift
//  FTCscorer
//
//  Created by Ayush Raman on 8/23/20.
//  Copyright © 2020 MSET Cuttlefish. All rights reserved.
//

import SwiftUI

struct matchNav: View {
    @EnvironmentObject var dataModel: DataModel
    @ObservedObject var match: Match
    @ObservedObject var red0: Score
    @ObservedObject var red1: Score
    @ObservedObject var blue0: Score
    @ObservedObject var blue1: Score
    let event: Event
    let index: Int
    init(_ m: Match, _ e: Event, index: Int = 0){
        match = m
        event = e
        self.index = index
        red0 = m.red.0.scores.find(m.id) 
        red1 = m.red.1.scores.find(m.id) 
        blue0 = m.blue.0.scores.find(m.id) 
        blue1 = m.blue.1.scores.find(m.id) 
    }
    var body: some View {
        switch event.type {
        case .virtual: return virtualMatchView().format()
        default: return localMatchView().format()
        }
    }
    func localMatchView() -> some View{
        NavigationLink(destination: MatchView(match, event).environmentObject(dataModel)){
            HStack{
                VStack{
                    Text("\(match.red.0.name ) & \(match.red.1.name )")
                        .font(.custom("", size: 14))
                    Text("VS")
                        .foregroundColor(Color.red)
                    Text("\(match.blue.0.name ) & \(match.blue.1.name )")
                        .font(.custom("", size: 14))
                }
                Spacer()
                Text("\(red0.val() + red1.val()) - \(blue0.val() + blue1.val())")
                    .padding(.trailing, 5)
            }
        }
    }
    func virtualMatchView() -> some View {
       NavigationLink(destination: MatchView(match, event)){
            HStack{
                Text("\(match.red.0.name) - Match \(index + 1)")
                Spacer()
                //Text(match.score())
                Text("\(red0.val())")
                    .padding(.trailing, 5)
            }
        }
    }
}

struct matchNav_Previews: PreviewProvider {
    static var previews: some View {
        matchNav(Match(red: (Team("2", "alphas"), Team("3", "betas")),blue: (Team("0", "charlies"), Team("1", "deltas"))), Event())
    }
}
