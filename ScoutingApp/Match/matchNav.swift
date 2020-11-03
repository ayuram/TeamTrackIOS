//
//  matchNav.swift
//  FTCscorer
//
//  Created by Ayush Raman on 8/23/20.
//  Copyright © 2020 MSET Cuttlefish. All rights reserved.
//

import SwiftUI

struct matchNav: View {
    @ObservedObject var match: Match
    init(_ m: Match){
        match = m
    }
    var body: some View {
        NavigationLink(destination: MatchView(match)){
            HStack{
                VStack{
                    Text("\(match.red.0.name) & \(match.red.1.name)")
                        .font(.custom("", size: 14))
                    
                    Text("VS")
                        .foregroundColor(Color.red)
                    
                    Text("\(match.blue.0.name) & \(match.blue.1.name)")
                        .font(.custom("", size: 14))
                }
                Spacer()
                Text(match.score())
//                Text("\((match.red.0.scores[match.id]?.val())! + (match.red.1.scores[match.id]?.val())!) - \((match.blue.0.scores[match.id]?.val())! + (match.blue.1.scores[match.id]?.val())!)")
//                    .padding(.trailing, 5)
            }
        }
    }
}

struct matchNav_Previews: PreviewProvider {
    static var previews: some View {
        matchNav(Match(red: (Team("2", "alphas"), Team("3", "betas")),blue: (Team("0", "charlies"), Team("1", "deltas"))))
    }
}
