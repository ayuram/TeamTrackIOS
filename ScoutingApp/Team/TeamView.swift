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
    func lineChart() -> some View{
        switch team.orderedScores().count{
        case 1: return AnyView(Text(""))
        default: return AnyView(LineView(data: [1, 6, 7, 3, 2, 9], title: "Timeline", style: ChartStyle(backgroundColor: .clear, accentColor: .red, gradientColor: GradientColor(start: .blue, end: .red), textColor: .black, legendTextColor: .gray, dropShadowColor: .red)).frame(height: 330))
//        default: return AnyView(LineView(data: team.orderedScores().map{Double($0.val())}, title: "Timeline", style: Styles.lineChartStyleOne).frame(height: 330))
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
