//
//  MatchView.swift
//  FTCscorer
//
//  Created by Ayush Raman on 8/24/20.
//  Copyright © 2020 MSET Cuttlefish. All rights reserved.
//

import SwiftUI

struct MatchView: View {
    @ObservedObject var match: Match
    @State var curr: currentView = .r0
    init(_ m: Match){
        match = m
    }
    enum currentView{
        case r0
        case r1
        case b0
        case b1
    }
    var body: some View {
       
            VStack{
                HStack{
                    Text("Match Stats")
                        .font(.largeTitle)
                        .bold()
                        .frame(alignment: .leading)
                        
                        .padding()
                    Spacer()
                }
                Spacer()
                HStack{
                    Spacer()
                    Text("\((match.red.0.scores[match.id]?.val())! + (match.red.1.scores[match.id]?.val())!)")
                        .font(.largeTitle)
                        .frame(width: 100)
                    Spacer()
                    Text("-")
                        .font(.largeTitle)
                    Spacer()
                    
                    Text("\((match.blue.0.scores[match.id]?.val())! + (match.blue.1.scores[match.id]?.val())!)")
                        .font(.largeTitle)
                        .frame(width: 100)
                    Spacer()
                }
                HStack{
                    Button("\(match.red.0.name.capitalized)"){
                        self.curr = .r0
                    }.disabled(self.curr == .r0)
                    .accentColor(.red)
                    Button("\(match.red.1.name.capitalized)"){
                        
                        self.curr = .r1
                    }.disabled(self.curr == .r1)
                    .accentColor(.red)
                    Spacer()
                    Button("\(match.blue.0.name.capitalized)"){
                        
                        self.curr = .b0
                    }.disabled(self.curr == .b0)
                    Button("\(match.blue.1.name.capitalized)"){
                        
                        self.curr = .b1
                    }.disabled(self.curr == .b1)
                }.padding()
                adjustments()
                
            }
            
        
    }
    func adjustments() -> some View{
        switch curr{
            case .r0: return Adjustments(match.red.0, match)
            case .r1: return Adjustments(match.red.1, match)
            case .b0: return Adjustments(match.blue.0, match)
            case .b1: return Adjustments(match.blue.1, match)
        }
    }
}
struct Adjustments: View{
    let team: Team
    let match: Match
    @State var state = currentState.auto
    enum currentState{
        case auto
        case tele
        case endgame
    }
    init(_ t: Team, _ m: Match){
        team = t
        match = m
    }
    var body: some View{
        VStack{
            Text("\(team.name.capitalized) : \((team.scores[match.id]?.val())!)")
                .font(.headline)
            Divider()
            HStack{
                Picker(selection: $state, label: Text("")){
                    Text("Autonomous").tag(currentState.auto)
                    Text("Tele-Op").tag(currentState.tele)
                    Text("Endgame").tag(currentState.endgame)
                }.pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 10)
                .accentColor(.blue)
            }
            Divider()
            ScrollView{
                view()
                    .frame(width: .infinity, height: 200, alignment: .top)
            }
                
        }
        
    }
    func view() -> some View{
        switch state{
        case .auto: return AnyView(Auto(team: team, match: match))
            
        case .tele: return AnyView(Tele(team: team, match: match))
            
        case .endgame: return AnyView(End(team: team, match: match))
            
        }
    }
}
struct End: View{
    @ObservedObject var team: Team
    let match: Match
    let lim: Int = Int.max
    var body: some View{
    
        VStack{
            HStack{
                Text("Power Shots")
                    .frame(width: 100, height: 10, alignment: .leading)
                    .padding()
                Spacer()
                Button(action: {
                    self.team.scores[match.id]!.endgame.pwrShots = self.team.scores[match.id]!.endgame.pwrShots - 1 < 0 ? 0 : self.team.scores[match.id]!.endgame.pwrShots - 1
                }){
                    Image(systemName: "minus.circle.fill")
                }
                Text("\(self.team.scores[match.id]!.endgame.pwrShots)")
                    .padding()
                Button(action: {
                    self.team.scores[match.id]!.endgame.pwrShots = self.team.scores[match.id]!.endgame.pwrShots + 1 > 3 ? 3 : self.team.scores[match.id]!.endgame.pwrShots + 1
                }){
                    Image(systemName:"plus.circle.fill")
                }
                Spacer()
            }
            HStack{
                Text("Wobbles in Drop")
                    .frame(width: 100, height: 10, alignment: .leading)
                    .padding()
                Spacer()
                Button(action: {
                    self.team.scores[match.id]!.endgame.wobbleGoalsinDrop = self.team.scores[match.id]!.endgame.wobbleGoalsinDrop - 1 < 0 ? 0 : self.team.scores[match.id]!.endgame.wobbleGoalsinDrop - 1
                }){
                    Image(systemName: "minus.circle.fill")
                }
                Text("\(self.team.scores[match.id]!.endgame.wobbleGoalsinDrop)")
                    .padding()
                Button(action: {
                    self.team.scores[match.id]!.endgame.wobbleGoalsinDrop = self.team.scores[match.id]!.endgame.wobbleGoalsinDrop + 1 < 0 ? 0 : self.team.scores[match.id]!.endgame.wobbleGoalsinDrop + 1
                }){
                    Image(systemName: "plus.circle.fill")
                }
                Spacer()
            }
            HStack{
                
                Text("Woobles in Start")
                    .frame(width: 100, height: 10, alignment: .leading)
                    .padding()
                Spacer()
                Button(action: {
                    self.team.scores[match.id]!.endgame.wobbleGoalsinStart = self.team.scores[match.id]!.endgame.wobbleGoalsinStart - 1 < 0 ? 0 : self.team.scores[match.id]!.endgame.wobbleGoalsinStart - 1
                }){
                    Image(systemName: "minus.circle.fill")
                }
                Text("\(self.team.scores[match.id]!.endgame.wobbleGoalsinStart)")
                    .padding()
                Button(action: {
                    self.team.scores[match.id]!.endgame.wobbleGoalsinStart = self.team.scores[match.id]!.endgame.wobbleGoalsinStart + 1 < 0 ? 0 : self.team.scores[match.id]!.endgame.wobbleGoalsinStart + 1
                }){
                    Image(systemName: "plus.circle.fill")
                }
                Spacer()
            }
            HStack{
                
                Text("Rings on Wobble")
                    .frame(width: 100, height: 10, alignment: .leading)
                    .padding()
                Spacer()
                Button(action: {
                    self.team.scores[match.id]!.endgame.ringsOnWobble = self.team.scores[match.id]!.endgame.ringsOnWobble - 1 < 0 ? 0 : self.team.scores[match.id]!.endgame.ringsOnWobble - 1
                }){
                    Image(systemName: "minus.circle.fill")
                }
                Text("\(self.team.scores[match.id]!.endgame.ringsOnWobble)")
                    .padding()
                Button(action: {
                    self.team.scores[match.id]!.endgame.ringsOnWobble = self.team.scores[match.id]!.endgame.ringsOnWobble + 1 < 0 ? 0 : self.team.scores[match.id]!.endgame.ringsOnWobble + 1
                }){
                    Image(systemName: "plus.circle.fill")
                }
                Spacer()
            }
            
        }
    
    }
}
struct Tele: View{
    @ObservedObject var team: Team
    let match: Match
    let lim: Int = Int.max
    var body: some View{
  
        VStack{
            HStack{
                Text("High Goals")
                    .frame(width: 100, height: 10, alignment: .leading)
                    .padding()
                Spacer()
                Button(action: {
                    self.team.scores[match.id]!.tele.hiGoals = self.team.scores[match.id]!.tele.hiGoals - 1 < 0 ? 0 : self.team.scores[match.id]!.tele.hiGoals - 1
                }){
                    Image(systemName: "minus.circle.fill")
                }
                Text("\(self.team.scores[match.id]!.tele.hiGoals)")
                    .padding()
                Button(action: {
                    self.team.scores[match.id]!.tele.hiGoals = self.team.scores[match.id]!.tele.hiGoals + 1 < 0 ? 0 : self.team.scores[match.id]!.tele.hiGoals + 1
                }){
                    Image(systemName: "plus.circle.fill")
                }
                Spacer()
            }
            HStack{
                Text("Middle Goals")
                    .frame(width: 100, height: 10, alignment: .leading)
                    .padding()
                Spacer()
                Button(action: {
                    self.team.scores[match.id]!.tele.midGoals = self.team.scores[match.id]!.tele.midGoals - 1 < 0 ? 0 : self.team.scores[match.id]!.tele.midGoals - 1
                }){
                    Image(systemName: "minus.circle.fill")
                }
                Text("\(self.team.scores[match.id]!.tele.midGoals)")
                    .padding()
                Button(action: {
                    self.team.scores[match.id]!.tele.midGoals = self.team.scores[match.id]!.tele.midGoals + 1 < 0 ? 0 : self.team.scores[match.id]!.tele.midGoals + 1
                }){
                    Image(systemName: "plus.circle.fill")
                }
                Spacer()
            }
            HStack{
                
                Text("Low Goals")
                    .frame(width: 100, height: 10, alignment: .leading)
                    .padding()
                Spacer()
                Button(action: {
                    self.team.scores[match.id]!.tele.lowGoals = self.team.scores[match.id]!.tele.lowGoals - 1 < 0 ? 0 : self.team.scores[match.id]!.tele.lowGoals - 1
                }){
                    Image(systemName: "minus.circle.fill")
                }
                Text("\(self.team.scores[match.id]!.tele.lowGoals)")
                    .padding()
                Button(action: {
                    self.team.scores[match.id]!.tele.lowGoals = self.team.scores[match.id]!.tele.lowGoals + 1 < 0 ? 0 : self.team.scores[match.id]!.tele.lowGoals + 1
                }){
                    Image(systemName: "plus.circle.fill")
                }
                Spacer()
            }
            
        }
    
    }
}
struct Auto: View{
    @ObservedObject var team: Team
    let match: Match
    let lim: Int = Int.max
    var body: some View{
        VStack{
            HStack{
                Text("High Goals")
                    .frame(width: 100, height: 10, alignment: .leading)
                    .padding()
                Spacer()
                Button(action: {
                    self.team.scores[match.id]!.auto.hiGoals = self.team.scores[match.id]!.auto.hiGoals - 1 < 0 ? 0 : self.team.scores[match.id]!.auto.hiGoals - 1
                }){
                    Image(systemName: "minus.circle.fill")
                }
                Text("\(self.team.scores[match.id]!.auto.hiGoals)")
                    .padding()
                Button(action: {
                    self.team.scores[match.id]!.auto.hiGoals = self.team.scores[match.id]!.auto.hiGoals + 1 < 0 ? 0 : self.team.scores[match.id]!.auto.hiGoals + 1
                }){
                    Image(systemName: "plus.circle.fill")
                }
                Spacer()
            }
            HStack{
                Text("Middle Goals")
                    .frame(width: 100, height: 10, alignment: .leading)
                    .padding()
                Spacer()
                Button(action: {
                    self.team.scores[match.id]!.auto.midGoals = self.team.scores[match.id]!.auto.midGoals - 1 < 0 ? 0 : self.team.scores[match.id]!.auto.midGoals - 1
                }){
                    Image(systemName: "minus.circle.fill")
                }
                Text("\(self.team.scores[match.id]!.auto.midGoals)")
                    .padding()
                Button(action: {
                    self.team.scores[match.id]!.auto.midGoals = self.team.scores[match.id]!.auto.midGoals + 1 < 0 ? 0 : self.team.scores[match.id]!.auto.midGoals + 1
                }){
                    Image(systemName: "plus.circle.fill")
                }
                Spacer()
            }
            HStack{
                
                Text("Low Goals")
                    .frame(width: 100, height: 10, alignment: .leading)
                    .padding()
                Spacer()
                Button(action: {
                    self.team.scores[match.id]!.auto.lowGoals = self.team.scores[match.id]!.auto.lowGoals - 1 < 0 ? 0 : self.team.scores[match.id]!.auto.lowGoals - 1
                }){
                    Image(systemName: "minus.circle.fill")
                }
                Text("\(self.team.scores[match.id]!.auto.lowGoals)")
                    .padding()
                Button(action: {
                    self.team.scores[match.id]!.auto.lowGoals = self.team.scores[match.id]!.auto.lowGoals + 1 < 0 ? 0 : self.team.scores[match.id]!.auto.lowGoals + 1
                }){
                    Image(systemName: "plus.circle.fill")
                }
                Spacer()
            }
            HStack{
                Text("Wobbles")
                    .frame(width: 100, height: 10, alignment: .leading)
                    .padding()
                Spacer()
                Button(action: {
                    self.team.scores[match.id]!.auto.wobbleGoals = self.team.scores[match.id]!.auto.wobbleGoals - 1 < 0 ? 0 : self.team.scores[match.id]!.auto.wobbleGoals - 1
                }){
                    Image(systemName: "minus.circle.fill")
                }
                Text("\(self.team.scores[match.id]!.auto.wobbleGoals)")
                    .padding()
                Button(action: {
                    self.team.scores[match.id]!.auto.wobbleGoals = self.team.scores[match.id]!.auto.wobbleGoals + 1 > 2 ? 2 : self.team.scores[match.id]!.auto.wobbleGoals + 1
                }){
                    Image(systemName: "plus.circle.fill")
                }
                Spacer()
            }
            HStack{
                Text("Power Shots")
                    .frame(width: 100, height: 10, alignment: .leading)
                    .padding()
                Spacer()
                Button(action: {
                    self.team.scores[match.id]!.auto.pwrShots = self.team.scores[match.id]!.auto.pwrShots - 1 < 0 ? 0 : self.team.scores[match.id]!.auto.pwrShots - 1
                }){
                    Image(systemName: "minus.circle.fill")
                }
                Text("\(self.team.scores[match.id]!.auto.pwrShots)")
                    .padding()
                Button(action: {
                    self.team.scores[match.id]!.auto.pwrShots = self.team.scores[match.id]!.auto.pwrShots + 1 > 3 ? 3 : self.team.scores[match.id]!.auto.pwrShots + 1
                }){
                    Image(systemName: "plus.circle.fill")
                }
                Spacer()
            }
            HStack{
                Text("Navigated")
                    .frame(width: 100, height: 10, alignment: .leading)
                    .padding()
                Spacer()
                Button(action: {
                    self.team.scores[match.id]!.auto.navigated = self.team.scores[match.id]!.auto.navigated - 1 < 0 ? 0 : self.team.scores[match.id]!.auto.navigated - 1
                }){
                    Image(systemName: "minus.circle.fill")
                }
                Text("\(self.team.scores[match.id]!.auto.navigated)")
                    .padding()
                Button(action: {
                    self.team.scores[match.id]!.auto.navigated = self.team.scores[match.id]!.auto.navigated + 1 > 2 ? 2 : self.team.scores[match.id]!.auto.navigated + 1
                }){
                    Image(systemName: "plus.circle.fill")
                }
                Spacer()
            }
        }
    
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(Match(red: (Team("2", "alphas"), Team("3", "betas")),blue: (Team("0", "charlies"), Team("1", "deltas"))))
    }
}
