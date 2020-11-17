//
//  TeamView.swift
//  FTCscorer
//
//  Created by Ayush Raman on 10/5/20.
//  Copyright © 2020 MSET Cuttlefish. All rights reserved.
//

import SwiftUI
import SwiftUICharts
extension View{
    func navLink(_ v: AnyView) -> some View{
        NavigationLink(destination: v.padding()){
            self
                .buttonStyle(PlainButtonStyle())
        }
    }
}
struct TeamView: View {
    @ObservedObject var team: Team
    @ObservedObject var data: Data
    @State private var animateChart = false
    @State var sheet = false
    let maxWidth = UIScreen.main.bounds.width
    let cardWidth = UIScreen.main.bounds.width - 50
    let defaultAnimation = Animation.easeInOut
    let newHeight: CGFloat = 500
    @State var genBool = false
    @State var autoBool = false
    @State var teleBool = false
    @State var endBool = false
    var body: some View {
            ScrollView {
                VStack {
                    lineChart()
                        Text("General")
                            .bold()
                            .padding()
                            .animation(.easeInOut)
                    GeometryReader{ geometry in
                        CardView(){
                            VStack{
                            HStack{
                                BarGraph(name: "Average", val: team.avgScore(), max: data.maxScore())
                                    .frame(height: 100)
                                    .animation(.easeInOut)
                                Spacer()
                                BarGraph(name: "Best Score", val: team.bestScore(), max: data.maxScore())
                                    .frame(height: 100)
                                    .animation(.easeInOut)
                                Spacer()
                                BarGraph(name: "Consistency", val: data.lowestMAD(), max: team.MAD(), flip: true)
                                    .animation(.easeInOut)
                            }
                            .padding()
                                if genBool {
                                    LineChart(data: team.scores.map{CGFloat($0.val())})
                                        .padding()
                                }
                            }
                            .frame(height: genBool ? newHeight : 250)
                            .format()
                        }
                        .frame(width: genBool ? maxWidth : cardWidth, height: genBool ? newHeight : 250)
                        //.rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minY) / -25), axis: (x: genBool ? 0 : 10, y: 0, z: 0))
                    }
                    .frame(width: genBool ? maxWidth : cardWidth, height: genBool ? newHeight : 250)
                    .onTapGesture {
                        genBool.toggle()
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                    .animation(.easeInOut)
                    //Divider()
                    Text("Autonomous")
                        .bold()
                        .padding()
                        .animation(.easeInOut)
                    GeometryReader{ geometry in
                        CardView(){
                            VStack{
                            HStack{
                                BarGraph(name: "Average", val: team.avgAutoScore(), max: data.maxAutoScore())
                                    .frame(height: 100)
                                    .animation(.easeInOut)
                                Spacer()
                                BarGraph(name: "Best Score", val: team.bestAutoScore(), max: data.maxAutoScore())
                                    .frame(height: 100)
                                    .animation(.easeInOut)
                                Spacer()
                                BarGraph(name: "Consistency", val: data.lowestAutoMAD(), max: team.autoMAD(), flip: true)
                                    .animation(.easeInOut)
                            }
                            .padding()
                                if autoBool {
                                    LineChart(data: team.scores.map{CGFloat($0.auto.total())})
                                        .padding()
                                }
                            }
                            .frame(height: autoBool ? newHeight : 250)
                            .format()
                        }
                        .frame(width: autoBool ? maxWidth : cardWidth, height: autoBool ? newHeight : 250)
                        //.rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minY) / -25), axis: (x: autoBool ? 0 : 10, y: 0, z: 0))
                    }
                    .frame(width: autoBool ? maxWidth : cardWidth, height: autoBool ? newHeight : 250)
                    .onTapGesture {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        autoBool.toggle()
                    }
                    .animation(.easeInOut)
                    //Divider()
                    Text("Tele-Op")
                        .bold()
                        .padding()
                        .animation(.easeInOut)
                    GeometryReader{ geometry in
                        CardView(){
                            VStack{
                            HStack{
                                BarGraph(name: "Average", val: team.avgTeleScore(), max: data.maxTeleScore())
                                    .frame(height: 100)
                                    .animation(.easeInOut)
                                Spacer()
                                BarGraph(name: "Best Score", val: team.bestTeleScore(), max: data.maxTeleScore())
                                    .frame(height: 100)
                                    .animation(.easeInOut)
                                Spacer()
                                BarGraph(name: "Consistency", val: data.lowestTeleMAD(), max: team.teleMAD(), flip: true)
                                    .animation(.easeInOut)
                            }
                            .padding()
                                if teleBool {
                                    LineChart(data: team.scores.map{CGFloat($0.tele.total())})
                                        .padding()
                                }
                            }
                            .frame(height: teleBool ? newHeight : 250)
                            .format()
                        }
                        .frame(width: teleBool ? maxWidth : cardWidth, height: teleBool ? newHeight : 250)
                        //.rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minY) / -25), axis: (x: teleBool ? 0 : 10, y: 0, z: 0))
                    }
                    .frame(width: teleBool ? maxWidth : cardWidth, height: teleBool ? newHeight : 250)
                    .onTapGesture {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        teleBool.toggle()
                    }
                    .animation(.easeInOut)
                    //Divider()
                    Text("Endgame")
                        .bold()
                        .padding()
                        .animation(.easeInOut)
                    GeometryReader{ geometry in
                        CardView(){
                            VStack{
                            HStack{
                                BarGraph(name: "Average", val: team.avgEndScore(), max: data.maxEndScore())
                                    .frame(height: 100)
                                    .animation(.easeInOut)
                                Spacer()
                                BarGraph(name: "Best Score", val: team.bestEndScore(), max: data.maxEndScore())
                                    .frame(height: 100)
                                    .animation(.easeInOut)
                                Spacer()
                                BarGraph(name: "Consistency", val: data.lowestEndMAD(), max: team.endMAD(), flip: true)
                                    .animation(.easeInOut)
                            }
                            .padding()
                                if endBool {
                                    LineChart(data: team.scores.map{CGFloat($0.endgame.total())})
                                        .padding()
                                }
                            }
                            .frame(height: endBool ? newHeight : 250)
                            .format()
                        }
                        .frame(width: endBool ? maxWidth : cardWidth, height: endBool ? newHeight : 250)
                        //.rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minY) / -25), axis: (x: endBool ? 0 : 10, y: 0, z: 0))
                    }
                    .frame(width: endBool ? maxWidth : cardWidth, height: endBool ? newHeight : 250)
                    .onTapGesture {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        endBool.toggle()
                    }
                    .animation(.easeInOut)
                    Spacer()
                        .frame(height: 400)
                }
                .frame(width: maxWidth)
            }.navigationBarTitle(team.name)
            
        
    }
    func lineChart() -> some View{
        switch team.scores.count{
        case 0: return AnyView(Text(""))
        default: return AnyView(LineChart(data: team.scores.map{CGFloat($0.val())}).frame(height: 360))
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
