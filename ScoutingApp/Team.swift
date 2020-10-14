//
//  Team.swift
//  FTCscorer
//
//  Created by Ayush Raman on 8/23/20.
//  Copyright © 2020 MSET Cuttlefish. All rights reserved.
//

import Foundation

extension Int{
    func double() -> Double{
        Double(self)
    }
}

struct AutoScore{
    var wobbleGoals: Int = 0
    var lowGoals: Int = 0
    var midGoals: Int = 0
    var hiGoals: Int = 0
    var pwrShots: Int = 0
    var navigated: Int = 0
    func total() -> Int{
        wobbleGoals * 15 + lowGoals * 3 + midGoals * 6 + hiGoals * 12 + pwrShots * 15 + navigated * 5
    }
}
struct TeleScore{
    var lowGoals: Int = 0
    var midGoals: Int = 0
    var hiGoals: Int = 0
    func total() -> Int{
        lowGoals * 2 + midGoals * 4 + hiGoals * 6
    }
}
struct EndgameScore {
    var pwrShots: Int = 0
    var wobbleGoalsinDrop: Int = 0
    var wobbleGoalsinStart: Int = 0
    var ringsOnWobble: Int = 0
    func total() -> Int {
        pwrShots * 15 + wobbleGoalsinDrop * 20 + wobbleGoalsinStart * 5 + ringsOnWobble * 5
    }
}
struct Score {
    var auto = AutoScore()
    var tele = TeleScore()
    var endgame = EndgameScore()
    func val() -> Int {
        auto.total() + tele.total() + endgame.total()
    }
    static func < (_ lhs: Score, _ rhs: Score) -> Bool{
        lhs.val() < rhs.val()
    }
    static func > (_ lhs: Score, _ rhs: Score) -> Bool{
        lhs.val() > rhs.val()
    }
}
extension Array where Element == Double{
    func mean() -> Double{
        (self.reduce(0.0) { $0 + $1 })/(self.count.double() == 0 ? 1 : self.count.double())
    }
    func MAD() -> Double{
        self.map{ abs($0 - self.mean()) }.mean()
    }
}
enum Aspect{
    case auto
    case tele
    case endgame
}
class Team: ObservableObject, Identifiable{
    let number: String
    var name: String
    var ids: [UUID] = []
    @Published var scores: Dictionary<UUID, Score> = [:]
    init(_ n: String,_ s: String){
        number = n
        name = s
    }
    func orderedScores() -> [Score]{
        ids.map { scores[$0] ?? Score() }
    }
    func avgScore() -> Double{
        switch scores.map({$1.val()}).count{
            case 0: return 0
        default: return scores.map{Double($1.val())}.mean()
        }
    }
    func avgAutoScore() -> Double {
        switch scores.map({$1.val()}).count{
        case 0: return 0
        default: return scores.map{$1.auto.total().double()}.mean()
        }
    }
    func avgTeleScore() -> Double {
        switch scores.map({$1.val()}).count{
        case 0: return 0
        default: return scores.map{$1.tele.total().double()}.mean()
        }
    }
    func avgEndScore() -> Double {
        switch scores.map({$1.val()}).count{
        case 0: return 0
        default: return scores.map{$1.endgame.total().double()}.mean()
        }
    }
    func bestScore() -> Double {
       scores.compactMap{ Double($1.val()) }.max() ?? 0
    }
    func bestAutoScore() -> Double {
        scores.compactMap { $1.auto.total().double() }.max() ?? 0
    }
    func bestTeleScore() -> Double {
        scores.compactMap { $1.tele.total().double() }.max() ?? 0
    }
    func bestEndScore() -> Double {
        scores.compactMap { $1.endgame.total().double() }.max() ?? 0
    }
    func MAD() -> Double{
        scores.map {$1.val().double()}.MAD()
    }
    func autoMAD() -> Double{
        scores.map {$1.auto.total().double()}.MAD()
    }
    func teleMAD() -> Double{
        scores.map {$1.tele.total().double()}.MAD()
    }
    func endMAD() -> Double{
        scores.map {$1.endgame.total().double()}.MAD()
    }
    static func < (_ lhs: Team, _ rhs: Team) -> Bool{
        lhs.number < rhs.number
    }
    static func > (_ lhs: Team, _ rhs: Team) -> Bool{
        lhs.number > rhs.number
    }
}
typealias side = (Team, Team)
class Match: Identifiable, ObservableObject{
    var id: UUID
    @Published var red: side
    @Published var blue: side
    init(red: side, blue: side){
        id = UUID()
        red.0.scores[id] = Score()
        red.1.scores[id] = Score()
        blue.0.scores[id] = Score()
        blue.1.scores[id] = Score()
        self.red = red
        self.blue = blue
    }
    
    func score() -> String{
        let r1 = red.0.scores[id]
        let r2 = red.1.scores[id]
        let b1 = blue.0.scores[id]
        let b2 = blue.0.scores[id]

        return "\((r1?.val())! + (r2?.val())!) - \((b1?.val())! + (b2?.val())!)"
        
    }
}

class Data: ObservableObject{
    @Published var teams: [Team]
    @Published var matches: [Match]
    @Published var user: Team?
    init(){
        teams = []
        matches = []
        user = .none
    }
    func weakestAspect() -> Aspect? {
        switch user{
        case .none: return .none
        default: return [(user!.avgAutoScore()/maxAutoScore(), Aspect.auto), (user!.avgTeleScore()/maxTeleScore(), Aspect.tele), (user!.avgEndScore()/maxEndScore(), Aspect.endgame)].min(by: { $0.0 < $1.0 } )!.1
        }
    }
    func setUser(_ t: Team){
        addTeam(t)
        user = t
    }
    func idealAlliance() -> Team? {
        switch weakestAspect(){
        case .none: return .none
        case .auto: return teams.max { $0.avgAutoScore() > $1.avgAutoScore() }
        case .tele: return teams.max { $0.avgTeleScore() > $1.avgTeleScore() }
        case .endgame: return teams.max { $0.avgEndScore() > $1.avgEndScore() }
        }
    }
    func bestTeam() -> [Team]?{
        let arr = teams.sorted { $0.avgScore() > $1.avgScore() }[0 ... 3]
        return Array(arr)
    }
    func addTeam(_ team: Team){
        var bool: Bool = false
        teams.map {
            if($0.number == team.number){
                bool = true
            }
        }
        if(!bool){
            teams.append(team)
        }
        sortTeams()
    }
    func addMatch(_ match: Match){
        var bool: Bool = false
        matches.map {
            if($0.id == match.id){
                bool = true
            }
        }
        if(!bool){
            matches.append(match)
            match.red.0.ids.append(match.id)
            match.red.1.ids.append(match.id)
            match.blue.0.ids.append(match.id)
            match.blue.1.ids.append(match.id)
        }
        
    }
    func sortTeams() -> Void{
        teams.sort(by: <)
    }
    func dictTeams() -> Dictionary<String, Team>{
        teams.reduce(into: [String : Team]()) {
            $0[$1.number] = $1
        }
    }
    func maxScore() -> Double {
        teams
            .map { $0.bestScore() }
            .max() ?? 0
    }
    func maxAutoScore() -> Double {
        teams
            .map { $0.bestAutoScore() }
            .max() ?? 0
    }
    func maxTeleScore() -> Double {
        teams
            .map { $0.bestTeleScore() }
            .max() ?? 0
    }
    func maxEndScore() -> Double {
        teams
            .map { $0.bestEndScore() }
            .max() ?? 0
    }
    func lowestMAD() -> Double {
        teams
            .map { $0.MAD() }
            .min() ?? 0
    }
    func lowestTeleMAD() -> Double {
        teams
            .map { $0.teleMAD() }
            .min() ?? 0
    }
    func lowestAutoMAD() -> Double {
        teams
            .map { $0.autoMAD() }
            .min() ?? 0
    }
    func lowestEndMAD() -> Double {
        teams
            .map { $0.endMAD() }
            .min() ?? 0
    }
}

