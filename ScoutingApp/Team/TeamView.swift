//
//  TeamView.swift
//  FTCscorer
//
//  Created by Ayush Raman on 10/5/20.
//  Copyright © 2020 MSET Cuttlefish. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct TeamView: View {
    @ObservedObject var team: Team
    @ObservedObject var data: Data
    @State private var animateChart = false
    @State var sheet = false
    var body: some View {
            ScrollView {
                VStack {
                    lineChart()
                        Text("General")
                            .bold()
                            .padding()
                    NavigationLink(destination: BarFullView(points: team.scores.map{ Double($0.val()) }, barGraph: BarGraph(name: "Best Score", val: team.bestAutoScore(), max: data.maxAutoScore())){[
                        AnyView(Text("Hello"))
                    ]}){
                        CardView(){
                            HStack{
                                BarGraph(name: "Average", val: team.avgScore(), max: data.maxScore())
                                    .animation(.easeInOut)
                                Spacer()
                                BarGraph(name: "Best Score", val: team.bestScore(), max: data.maxScore())
                                    .animation(.easeInOut)
                                Spacer()
                                BarGraph(name: "Consistency", val: 1, max: team.MAD(), flip: true)
                                    .animation(.easeInOut)
                            }
                            .padding()
                            .frame(height: 100)
                            .format()
                        }.buttonStyle(PlainButtonStyle())
                    }
                    //Divider()
                    Text("Autonomous")
                        .bold()
                        .padding()
                    NavigationLink(destination: BarFullView(points: team.scores.map{ Double($0.auto.total()) }, barGraph: BarGraph(name: "Best Score", val: team.bestAutoScore(), max: data.maxAutoScore())){[
                        AnyView(Text("Hello"))
                    ]}){
                        CardView(){
                            HStack{
                                BarGraph(name: "Average", val: team.avgAutoScore(), max: data.maxAutoScore())
                                    .animation(.easeInOut)
                                Spacer()
                                BarGraph(name: "Best Score", val: team.bestAutoScore(), max: data.maxAutoScore())
                                    .animation(.easeInOut)
                                Spacer()
                                BarGraph(name: "Consistency", val: data.lowestMAD(), max: team.autoMAD(), flip: true)
                                    .animation(.easeInOut)
                            }
                            .padding()
                            .frame(height: 100)
                            .format()
                        }.buttonStyle(PlainButtonStyle())
                    }
                    //Divider()
                    Text("Tele-Op")
                        .bold()
                        .padding()
                    NavigationLink(destination: BarFullView(points: team.scores.map{ Double($0.tele.total()) }, barGraph: BarGraph(name: "Best Score", val: team.bestAutoScore(), max: data.maxAutoScore())){[
                        AnyView(Text("Hello"))
                    ]}){
                        CardView(){
                            HStack{
                                BarGraph(name: "Average", val: team.avgTeleScore(), max: data.maxTeleScore())
                                    .animation(.easeInOut)
                                Spacer()
                                BarGraph(name: "Best Score", val: team.bestTeleScore(), max: data.maxTeleScore())
                                    .animation(.easeInOut)
                                Spacer()
                                BarGraph(name: "Consistency", val: 1, max: team.teleMAD(), flip: true)
                                    .animation(.easeInOut)
                            }
                            .padding()
                            .frame(height: 100)
                            .format()
                        }
                    }
                    //Divider()
                    Text("Endgame")
                        .bold()
                        .padding()
                    NavigationLink(destination: BarFullView(points: team.scores.map{ Double($0.endgame.total()) }, barGraph: BarGraph(name: "Best Score", val: team.bestAutoScore(), max: data.maxAutoScore())){[
                        AnyView(Text("Hello"))
                    ]}){
                        CardView(){
                            HStack{
                                BarGraph(name: "Average", val: team.avgEndScore(), max: data.maxEndScore())
                                    .animation(.easeInOut)
                                Spacer()
                                BarGraph(name: "Best Score", val: team.bestEndScore(), max: data.maxEndScore())
                                    .animation(.easeInOut)
                                Spacer()
                                BarGraph(name: "Consistency", val: 1, max: team.endMAD(), flip: true)
                                    .animation(.easeInOut)
                            }
                            .padding()
                            .frame(height: 100)
                            .format()
                        }.buttonStyle(PlainButtonStyle())
                    }
                    Spacer()
                }
                .padding()
                .navigationBarTitle(team.name)
                
            }
            
        
    }
    func lineChart() -> some View{
        switch team.scores.count{
        case 0: return AnyView(Text(""))
        default: return AnyView(LineView(data: team.scores.map{Double($0.val())}, title: "Timeline", style: ChartStyle(backgroundColor: .clear, accentColor: .red, gradientColor: GradientColor(start: .blue, end: .red), textColor: .black, legendTextColor: .gray, dropShadowColor: .red)).frame(height: 330))
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
        TeamView(team: Team("11", "A"), data: Data())
    }
}
