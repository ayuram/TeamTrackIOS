//
//  TeamView.swift
//  FTCscorer
//
//  Created by Ayush Raman on 10/5/20.
//  Copyright © 2020 MSET Cuttlefish. All rights reserved.
//

import SwiftUI

extension View{
    func navLink(_ v: AnyView) -> some View{
        NavigationLink(destination: v.padding()){
            self
                .buttonStyle(PlainButtonStyle())
        }
    }
}
struct MyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}
struct TeamView: View {
    @ObservedObject var team: Team
    @ObservedObject var data: Data
    @State private var animateChart = false
    @State var sheet = false
    let maxWidth = UIScreen.main.bounds.width
    let cardWidth = UIScreen.main.bounds.width - 50
    let defaultAnimation = Animation.interactiveSpring(response: 0.3, dampingFraction: 0.6, blendDuration: 1)
    let newHeight: CGFloat = 500
    @State var genBool = false
    @State var autoBool = false
    @State var teleBool = false
    @State var endBool = false
    var body: some View {
        ScrollView {
            VStack {
                //LineView(data: [1, 5, 3, 2, 1])
                lineChart()
                Text("General")
                    .bold()
                    .padding()
                    .animation(defaultAnimation)
                Button(action: {
                    genBool.toggle()
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }, label: {
                    CardView(){
                        VStack{
                            HStack{
                                BarGraph(name: "Average", val: team.avgScore(), max: data.maxScore())
                                    .frame(height: 100)
                                    .animation(defaultAnimation)
                                Spacer()
                                BarGraph(name: "Best Score", val: team.bestScore(), max: data.maxScore())
                                    .frame(height: 100)
                                    .animation(defaultAnimation)
                                Spacer()
                                BarGraph(name: "Consistency", val: data.lowestMAD(), max: team.MAD(), flip: true)
                                    .animation(defaultAnimation)
                            }
                            .padding()
                            if genBool {
                                LineChart(data: team.scores.map{CGFloat($0.val())})
                                    .padding()
                                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
                            }
                        }
                        .frame(height: genBool ? newHeight : 250)
                        .format()
                    }
                    .frame(width: genBool ? maxWidth : cardWidth, height: genBool ? newHeight : 250)
                })
                .buttonStyle(MyButtonStyle())
                .animation(defaultAnimation)
                Text("Autonomous")
                    .bold()
                    .padding()
                    .animation(defaultAnimation)
                Button(action: {
                    autoBool.toggle()
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }, label: {
                    CardView(){
                        VStack{
                            HStack{
                                BarGraph(name: "Average", val: team.avgAutoScore(), max: data.maxAutoScore())
                                    .frame(height: 100)
                                    .animation(defaultAnimation)
                                Spacer()
                                BarGraph(name: "Best Score", val: team.bestAutoScore(), max: data.maxAutoScore())
                                    .frame(height: 100)
                                    .animation(defaultAnimation)
                                Spacer()
                                BarGraph(name: "Consistency", val: data.lowestAutoMAD(), max: team.autoMAD(), flip: true)
                                    .animation(defaultAnimation)
                            }
                            .padding()
                            if autoBool {
                                LineChart(data: team.scores.map{CGFloat($0.auto.total())})
                                    .padding()
                                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
                            }
                        }
                        .frame(height: autoBool ? newHeight : 250)
                        .format()
                    }
                    .frame(width: autoBool ? maxWidth : cardWidth, height: autoBool ? newHeight : 250)
                })
                .buttonStyle(MyButtonStyle())
                .animation(defaultAnimation)
                //Divider()
                Text("Tele-Op")
                    .bold()
                    .padding()
                    .animation(defaultAnimation)
                Button(action: {
                    teleBool.toggle()
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }, label: {
                    CardView(){
                        VStack{
                            HStack{
                                BarGraph(name: "Average", val: team.avgTeleScore(), max: data.maxTeleScore())
                                    .frame(height: 100)
                                    .animation(defaultAnimation)
                                Spacer()
                                BarGraph(name: "Best Score", val: team.bestTeleScore(), max: data.maxTeleScore())
                                    .frame(height: 100)
                                    .animation(defaultAnimation)
                                Spacer()
                                BarGraph(name: "Consistency", val: data.lowestTeleMAD(), max: team.teleMAD(), flip: true)
                                    .animation(defaultAnimation)
                            }
                            .padding()
                            if teleBool {
                                LineChart(data: team.scores.map{CGFloat($0.tele.total())})
                                    .padding()
                                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
                            }
                        }
                        .frame(height: teleBool ? newHeight : 250)
                        .format()
                    }
                    .frame(width: teleBool ? maxWidth : cardWidth, height: teleBool ? newHeight : 250)
                })
                .buttonStyle(MyButtonStyle())
                .animation(defaultAnimation)
                //Divider()
                Text("Endgame")
                    .bold()
                    .padding()
                    .animation(defaultAnimation)
                Button(action: {
                    endBool.toggle()
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }, label: {
                    CardView(){
                        VStack{
                            HStack{
                                BarGraph(name: "Average", val: team.avgEndScore(), max: data.maxEndScore())
                                    .frame(height: 100)
                                    .animation(defaultAnimation)
                                Spacer()
                                BarGraph(name: "Best Score", val: team.bestEndScore(), max: data.maxEndScore())
                                    .frame(height: 100)
                                    .animation(defaultAnimation)
                                Spacer()
                                BarGraph(name: "Consistency", val: data.lowestEndMAD(), max: team.endMAD(), flip: true)
                                    .animation(defaultAnimation)
                            }
                            .padding()
                            if endBool {
                                LineChart(data: team.scores.map{CGFloat($0.endgame.total())})
                                    .padding()
                                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
                            }
                        }
                        .frame(height: endBool ? newHeight : 250)
                        .format()
                    }
                    .frame(width: endBool ? maxWidth : cardWidth, height: endBool ? newHeight : 250)
                })
                .animation(defaultAnimation)
                .buttonStyle(MyButtonStyle())
                Spacer()
                    .frame(height: 400)
            }
            .frame(width: maxWidth)
        }.navigationBarTitle(team.name)
        .navigationBarItems(leading: Button(action: {
            if isFullScreen(){
                genBool = false
                autoBool = false
                teleBool = false
                endBool = false
            }
            else{
                genBool = true
                autoBool = true
                teleBool = true
                endBool = true
            }
        }, label: {
            if isFullScreen() {
                Text("Collapse All")
            }
            else{
                Text("Expand All")
            }
        }))
        
        
    }
    func isFullScreen() -> Bool {
        genBool || autoBool || endBool || teleBool
    }
    func lineChart() -> some View{
        switch team.scores.count{
        case 0: return AnyView(Text(""))
        default: return AnyView(LineChart(data: team.scores.map{CGFloat($0.val())}).frame(height: 360).padding())
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
