//
//  TeamView.swift
//  FTCscorer
//
//  Created by Ayush Raman on 10/5/20.
//  Copyright © 2020 MSET Cuttlefish. All rights reserved.
//

import SwiftUI

struct TeamView: View {
    @ObservedObject var team: Team
    @ObservedObject var data: Data
    @State private var animateChart = false
    @State var sheet = false
    var body: some View {
        NavigationView{
            ScrollView {
                VStack {
                    HStack{
                        VStack{
                            Text("\(team.scores.map { $1.val() }.max() ?? 0)").bold()
                                Spacer()
                            Text("\(team.scores.map { $1.val() }.min() ?? 0)").bold()
                            
                        }
                        LineGraph(team.scores.map{CGFloat($1.val())}.normalized)
                            .trim(to: animateChart ? 1 : 0)
                            .stroke(Color.green)
                            .onAppear(perform: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                    self.animateChart = true
                                }
                            })
                            .animation(.easeInOut(duration: 2))
                            .border(Color.black)
                        Spacer()
                    }.frame(height: 360)
                    //Divider()
                    Text("General")
                        .bold()
                        .underline()
                        .padding()
                    HStack{
                        BarGraph(name: "Average", val: team.avgScore(), max: data.maxScore())
                        Spacer()
                        BarGraph(name: "Best Score", val: team.bestScore(), max: data.maxScore())
                        Spacer()
                        BarGraph(name: "Consistency", val: 1, max: team.MAD(), flip: true)
                    }
                    //Divider()
                    Text("Autonomous")
                        .bold()
                        .underline()
                        .padding()
                    HStack{
                        BarGraph(name: "Average", val: team.avgAutoScore(), max: data.maxAutoScore())
                        Spacer()
                        BarGraph(name: "Best Score", val: team.bestAutoScore(), max: data.maxAutoScore())
                        Spacer()
                        BarGraph(name: "Consistency", val: 1, max: team.autoMAD(), flip: true)
                    }
                    //Divider()
                    Text("Tele-Op")
                        .bold()
                        .underline()
                        .padding()
                    HStack{
                        BarGraph(name: "Average", val: team.avgTeleScore(), max: data.maxTeleScore())
                        Spacer()
                        BarGraph(name: "Best Score", val: team.bestTeleScore(), max: data.maxTeleScore())
                        Spacer()
                        BarGraph(name: "Consistency", val: 1, max: team.teleMAD(), flip: true)
                    }
                    //Divider()
                    Text("Endgame")
                        .bold()
                        .underline()
                        .padding()
                    HStack{
                        BarGraph(name: "Average", val: team.avgEndScore(), max: data.maxEndScore())
                        Spacer()
                        BarGraph(name: "Best Score", val: team.bestEndScore(), max: data.maxEndScore())
                        Spacer()
                        BarGraph(name: "Consistency", val: 1, max: team.endMAD(), flip: true)
                    }
                    Spacer()
                }
                .padding()
                .navigationBarTitle(team.name)
                
            }
            
        }
    }
}
extension Array where Element == CGFloat{
    var normalized: [CGFloat] {
        if let min = self.min(), let max = self.max(){
            return self.map { ($0 - min)/( max - min ) }
        }
        return []
    }
}
struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamView(team: Team("11", "Ayush"), data: Data())
    }
}
