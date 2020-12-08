//
//  MatchView.swift
//  FTCscorer
//
//  Created by Ayush Raman on 8/24/20.
//  Copyright © 2020 MSET Cuttlefish. All rights reserved.
//
import CoreHaptics
import SwiftUI

struct MatchView: View {
    @ObservedObject var match: Match
    @State var curr: currentView = .r0
    @ObservedObject var scoreRed0: Score
    @ObservedObject var scoreRed1: Score
    @ObservedObject var scoreBlue0: Score
    @ObservedObject var scoreBlue1: Score
    let event: Event
    @State var gradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color.red, Color("background"), Color("background"), Color("background"), Color("background")]), startPoint: .topTrailing, endPoint: .bottomLeading)
    init(_ m: Match, _ e: Event){
        match = m
        event = e
        scoreRed0 = (m.red.0.scores.find(m.id))
        scoreRed1 = (m.red.1.scores.find(m.id))
        scoreBlue0 = (m.blue.0.scores.find(m.id))
        scoreBlue1 = (m.blue.1.scores.find(m.id))
    }
    enum currentView{
        case r0
        case r1
        case b0
        case b1
    }
    var body: some View {
        ZStack{
            gradient
                .animation(.default)
                .ignoresSafeArea(.container, edges: .all)
                
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Text("\(scoreRed0.val() + scoreRed1.val())")
                        .font(.largeTitle)
                        .frame(width: 100)
                    Spacer()
                    Text("-")
                        .font(.largeTitle)
                    Spacer()
                    
                    Text("\(scoreBlue0.val() + scoreBlue1.val())")
                        .font(.largeTitle)
                        .frame(width: 100)
                    Spacer()
                }
                HStack(spacing: 20){
                    Button("\(match.red.0.name.capitalized)"){
                        self.curr = .r0
                        changeColor(color: .red)
                    }.disabled(self.curr == .r0)
                    .accentColor(.red)
                    
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    Button("\(match.red.1.name.capitalized)"){
                        self.curr = .r1
                        changeColor(color: .red)
                    }.disabled(self.curr == .r1)
                    .accentColor(.red)
                    
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    Spacer()
                    Button("\(match.blue.0.name.capitalized)"){
                        changeColor(color: .blue)
                        self.curr = .b0
                    }.disabled(self.curr == .b0)
                    .accentColor(.blue)
                   
                    .multilineTextAlignment(.center)
                    
                    Button("\(match.blue.1.name.capitalized)"){
                        changeColor(color: .blue)
                        self.curr = .b1
                    }.disabled(self.curr == .b1)
                    .accentColor(.blue)
                    
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                }.padding()
                adjustments()
                
            }
        }
            .navigationBarTitle("Match Stats")
        .onChange(of: match.score(), perform: { _ in
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    })
    }
    func changeColor(color: Color){
        gradient = LinearGradient(gradient: Gradient(colors: [color, Color("background"), Color("background"), Color("background"), Color("background")]), startPoint: .topTrailing, endPoint: .bottomLeading)
    }
    func adjustments() -> some View{
        switch curr{
        case .r0: return Adjustments(match.red.0, match, match.red.0.scores.find(match.id), event)
            case .r1: return Adjustments(match.red.1, match, match.red.1.scores.find(match.id), event)
            case .b0: return Adjustments(match.blue.0, match, match.blue.0.scores.find(match.id), event)
        case .b1: return Adjustments(match.blue.1, match, match.blue.1.scores.find(match.id), event)
        }
    }
}
struct Adjustments: View{
    @ObservedObject var team: Team
    @ObservedObject var score: Score
    let match: Match
    let data: Event
    @State var state = currentState.auto
    enum currentState{
        case auto
        case tele
        case endgame
    }
    init(_ t: Team, _ m: Match, _ s: Score, _ d: Event){
        team = t
        match = m
        score = s
        data = d
    }
    var body: some View{
        VStack{
            Text("\(team.name.capitalized) : \((score.val()))")
                .font(.headline)
            Divider()
            HStack{
                Picker(selection: $state, label: Text("")){
                    Text("Autonomous").tag(currentState.auto)
                    Text("Tele-Op").tag(currentState.tele)
                    Text("Endgame").tag(currentState.endgame)
                }.pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 5)
                .accentColor(.blue)
            }
            Divider()
                view()
                    .frame(width: UIScreen.main.bounds.width, alignment: .top)
            Spacer()
                
        }
        
    }
    func view() -> some View{
        switch state{
        case .auto: return AnyView(Auto(score: score, event: data))
            
        case .tele: return AnyView(Tele(score: score, event: data))
            
        case .endgame: return AnyView(End(score: score, event: data))
            
        }
    }
}
struct End: View{
    @ObservedObject var score: Score
    @State var engine: CHHapticEngine?
    var event: Event
    var body: some View{
        List{
            Stepper("\(score.endgame.pwrShots) Power Shots", value: $score.endgame.pwrShots, in: 0 ... 3)
            Stepper("\(score.endgame.wobbleGoalsinDrop) Wobbles in Drop", value: $score.endgame.wobbleGoalsinDrop, in: 0 ... 2)
            Stepper("\(score.endgame.wobbleGoalsinStart) Wobbles in Start", value: $score.endgame.wobbleGoalsinStart, in: 0 ... 2)
            Stepper("\(score.endgame.ringsOnWobble) Rings on Wobble", value: $score.endgame.ringsOnWobble, in: 0 ... Int.max)
            
        }
        .onChange(of: score.endgame, perform: { _ in
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    })
    }
    func complexSuccess() {
        guard
            CHHapticEngine.capabilitiesForHardware()
                .supportsHaptics else {return}
        var events = [CHHapticEvent]()
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch{
            print("Failed to play Pattern: \(error.localizedDescription).")
        }
    }
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware()
                .supportsHaptics else { return }
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
}
struct Tele: View{
    @ObservedObject var score: Score
    let event: Event
    var body: some View{
        List{
            Stepper("\(score.tele.hiGoals) High Goals", value: $score.tele.hiGoals, in: 0 ... Int.max)
            Stepper("\(score.tele.midGoals) Middle Goals", value: $score.tele.midGoals, in: 0 ... Int.max)
            Stepper("\(score.tele.lowGoals) Low Goals", value: $score.tele.lowGoals, in: 0 ... Int.max)
        }
        .onChange(of: score.tele, perform: { _ in
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    })
    }
}
struct Auto: View{
    @ObservedObject var score: Score
    let event: Event
    var body: some View{
        List{
            Stepper("\(score.auto.hiGoals) High Goals", value: $score.auto.hiGoals, in: 0 ... Int.max)
            Stepper("\(score.auto.midGoals) Middle Goals", value: $score.auto.midGoals, in: 0 ... Int.max)
            
            Stepper("\(score.auto.lowGoals) Low Goals", value: $score.auto.lowGoals, in: 0 ... Int.max)
            Stepper("\(score.auto.wobbleGoals) Wobbles Placed", value: $score.auto.wobbleGoals, in: 0 ... 2)
            Stepper("\(score.auto.pwrShots) Power Shots", value: $score.auto.pwrShots, in: 0 ... 3)
            Toggle(isOn: $score.auto.navigated) {
                Text("Navigated")
            }
        }
        .onChange(of: score.auto, perform: { _ in
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    })
    }
}
struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(Match(red: (Team("2", "ELementary Schooling People"), Team("3", "LOTS OF PEOPLE IN A ROOM")),blue: (Team("0", "charlies"), Team("1", "deltas"))), Event())
            
    }
}
