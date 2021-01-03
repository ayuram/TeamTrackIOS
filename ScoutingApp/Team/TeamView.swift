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
struct MyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
    }
}
struct TeamView: View {
    @EnvironmentObject var dataModel: DataModel
    @ObservedObject var team: Team
    @ObservedObject var event: Event
    @State private var animateChart = false
    let maxWidth = UIScreen.main.bounds.width
    let cardWidth = UIScreen.main.bounds.width - 50
    let defaultAnimation = Animation.interactiveSpring(response: 0.3, dampingFraction: 0.6, blendDuration: 1)
    let newHeight: CGFloat = 430
    let chartStyle = ChartStyle(backgroundColor: .clear, accentColor: .purple, gradientColor: GradientColor(start: .green, end: .blue), textColor: Color("text"), legendTextColor: Color.gray, dropShadowColor: .clear)
    @State var genBool = false
    @State var autoBool = false
    @State var teleBool = false
    @State var endBool = false
    @State var dice: Dice? = .none
    @State var alertBool = false
    var body: some View {
        ScrollView {
            VStack {
                //LineView(data: [1, 5, 3, 2, 1])
                lineChart()
                if event.type == .virtual{
                    NavigationLink(destination: MatchList(team: team, event: event).environmentObject(dataModel)){
                        Text("Matches")
                            .foregroundColor(.black)
                            .frame(width: UIScreen.main.bounds.width - 40, height: 40)
                            .background(Color.green)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: Color("text"),radius: 10)
                            .shadow(radius: 10)
                            .buttonStyle(PlainButtonStyle())
                    }
                }
                Group{
                    Text("General")
                        .bold()
                        .padding()
                        .animation(defaultAnimation)
                    Button(action: {
                        if team.scores.count > 1{
                            genBool.toggle()
                        } else {
                            alertBool.toggle()
                        }
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }, label: {
                        CardView(){
                            VStack{
                                HStack{
                                    BarGraph(name: "Average", val: team.avgScore(), max: event.maxScore())
                                        .frame(height: 100)
                                        .animation(defaultAnimation)
                                    Spacer()
                                    BarGraph(name: "Best Score", val: team.bestScore(), max: event.maxScore())
                                        .frame(height: 100)
                                        .animation(defaultAnimation)
                                    Spacer()
                                    BarGraph(name: "Consistency", val: event.lowestMAD(), max: team.MAD(), flip: true)
                                        .animation(defaultAnimation)
                                }
                                .padding()
                                if genBool {
                                    LineChartView(data: team.scores.map{Double($0.val())}, title: "Timeline", style: chartStyle,  form: ChartForm.large, rateValue: team.scores.map{Double($0.val())}.percentChange())
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
                }
                Group{
                    Text("Autonomous")
                        .bold()
                        .padding()
                        .animation(defaultAnimation)
                    Text("Stack Height")
                        .font(.caption)
                        .animation(defaultAnimation)
                    Picker(selection: $dice, label: Text("")){
                        Text("0").tag(Dice?.some(.one))
                        Text("1").tag(Dice?.some(.two))
                        Text("4").tag(Dice?.some(.three))
                        Text("All Cases").tag(Dice?.none)
                    }.pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 25)
                    .padding(.bottom, 5)
                    .animation(defaultAnimation)
                
                    Button(action: {
                        if team.scores.count > 1{
                            autoBool.toggle()
                        } else {
                            alertBool.toggle()
                        }
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }, label: {
                        CardView(){
                            VStack{
                                HStack{
                                    BarGraph(name: "Average", val: team.avgAutoScore(dice: dice), max: event.maxAutoScore(dice: dice))
                                        .frame(height: 100)
                                        .animation(defaultAnimation)
                                    Spacer()
                                    BarGraph(name: "Best Score", val: team.bestAutoScore(dice: dice), max: event.maxAutoScore(dice: dice))
                                        .frame(height: 100)
                                        .animation(defaultAnimation)
                                    Spacer()
                                    BarGraph(name: "Consistency", val: event.lowestAutoMAD(dice: dice), max: team.autoMAD(dice: dice), flip: true)
                                        .frame(height: 100)
                                        .animation(defaultAnimation)
                                }
                                .padding()
                                if autoBool && (dice == .none ?  team.scores.map{Double($0.auto.total())}.count : team.scores.filter{$0.scoringCase == dice}.count) >= 2{
                                    LineChartView(data: dice == .none ?  team.scores.map{Double($0.auto.total())} : team.scores.filter{$0.scoringCase == dice}.map{Double($0.auto.total())}, title: "Timeline", style: chartStyle, form: ChartForm.large, rateValue: dice == .none ?  team.scores.map{Double($0.auto.total())}.percentChange() : team.scores.filter{$0.scoringCase == dice}.map{Double($0.auto.total())}.percentChange())
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
                
                }
                Text("Tele-Op")
                    .bold()
                    .padding()
                    .animation(defaultAnimation)
                Button(action: {
                    if team.scores.count > 1{
                        teleBool.toggle()
                    } else {
                        alertBool.toggle()
                    }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }, label: {
                    CardView(){
                        VStack{
                            HStack{
                                BarGraph(name: "Average", val: team.avgTeleScore(), max: event.maxTeleScore())
                                    .frame(height: 100)
                                    .animation(defaultAnimation)
                                Spacer()
                                BarGraph(name: "Best Score", val: team.bestTeleScore(), max: event.maxTeleScore())
                                    .frame(height: 100)
                                    .animation(defaultAnimation)
                                Spacer()
                                BarGraph(name: "Consistency", val: event.lowestTeleMAD(), max: team.teleMAD(), flip: true)
                                    .animation(defaultAnimation)
                            }
                            .padding()
                            if teleBool {
                                //LineChart(data: team.scores.map{CGFloat($0.tele.total())})
                                LineChartView(data: team.scores.map{Double($0.tele.total())}, title: "Timeline", style: chartStyle, form: ChartForm.large, rateValue: team.scores.map{Double($0.tele.total())}.percentChange())
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
                    if team.scores.count > 1{
                        endBool.toggle()
                    } else {
                        alertBool.toggle()
                    }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }, label: {
                    CardView(){
                        VStack{
                            HStack{
                                BarGraph(name: "Average", val: team.avgEndScore(), max: event.maxEndScore())
                                    .frame(height: 100)
                                    .animation(defaultAnimation)
                                Spacer()
                                BarGraph(name: "Best Score", val: team.bestEndScore(), max: event.maxEndScore())
                                    .frame(height: 100)
                                    .animation(defaultAnimation)
                                Spacer()
                                BarGraph(name: "Consistency", val: event.lowestEndMAD(), max: team.endMAD(), flip: true)
                                    .animation(defaultAnimation)
                            }
                            .padding()
                            if endBool {
                                LineChartView(data: team.scores.map{Double($0.endgame.total())}, title: "Timeline", style: chartStyle, form: ChartForm.large, rateValue: team.scores.map{Double($0.endgame.total())}.percentChange())
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
                    .frame(height: 300)
            }
        }.navigationBarTitle(team.name)
        .navigationBarItems(trailing: Button(action: {
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
        .alert(isPresented: $alertBool, content: {
            Alert(title: Text("Not Enough Data"), message: Text("Enter more scores..."), dismissButton: .default(Text("Okay")))
        })
    }
    func isFullScreen() -> Bool {
        genBool || autoBool || endBool || teleBool
    }
    func lineChart() -> some View{
        if(team.scores.count < 2){
            return AnyView(Text(""))
        }
        else{
            return AnyView(LineView(data: team.scores.map{Double($0.val())}, legend: "Timeline", style: chartStyle).frame(height: 360).padding())
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
extension Array where Element == Double{
    func percentChange() -> Int {
        if self.count < 2 {
            return 0
        } else if self.mean() != 0{
            return Int(((self.last ?? 0) - self.mean())/self.mean() * 100)
        } else {
            return 100
        }
    }
}
struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamView(team: Team("11", "A"), event: Event())
            .environmentObject(DataModel())
    }
}
