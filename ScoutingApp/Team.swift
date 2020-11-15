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

struct AutoScore: Codable{
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
struct TeleScore: Codable{
    var lowGoals: Int = 0
    var midGoals: Int = 0
    var hiGoals: Int = 0
    func total() -> Int{
        lowGoals * 2 + midGoals * 4 + hiGoals * 6
    }
}
struct EndgameScore: Codable{
    var pwrShots: Int = 0
    var wobbleGoalsinDrop: Int = 0
    var wobbleGoalsinStart: Int = 0
    var ringsOnWobble: Int = 0
    func total() -> Int {
        pwrShots * 15 + wobbleGoalsinDrop * 20 + wobbleGoalsinStart * 5 + ringsOnWobble * 5
    }
}
class Score: Identifiable, ObservableObject{
    var id: UUID
    @Published var auto = AutoScore()
    @Published var tele = TeleScore()
    @Published var endgame = EndgameScore()
    init(_ m: Match){
        id = m.id
    }
    init(_ id: UUID){
        self.id = id
    }
    init(){
        id = UUID()
    }
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
extension Array where Element == Score{
    func find(_ id: UUID) -> Score{
        self.reduce(Score()){ $1.id == id ? $1 : $0}
    }
    func avgAutoScore() -> Double {
        switch self.map({$0.val()}).count{
        case 0: return 0
        default: return self.map{$0.auto.total().double()}.mean()
        }
    }
    func avgTeleScore() -> Double {
        switch self.map({$0.val()}).count{
        case 0: return 0
        default: return self.map{$0.tele.total().double()}.mean()
        }
    }
    func avgEndScore() -> Double {
        switch self.map({$0.val()}).count{
        case 0: return 0
        default: return self.map{$0.endgame.total().double()}.mean()
        }
    }
    func avgScore() -> Double{
        switch self.map({$0.val()}).count{
            case 0: return 0
        default: return self.map{Double($0.val())}.mean()
        }
    }
}
class Team: ObservableObject, Identifiable{
    let number: String
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    var name: String
    @Published var scores: [Score] = []
    init(_ n: String,_ s: String){
        number = n
        name = s
    }
    func avgScore() -> Double{
        switch scores.map({$0.val()}).count{
            case 0: return 0
        default: return scores.map{Double($0.val())}.mean()
        }
    }
    func avgAutoScore() -> Double {
        switch scores.map({$0.val()}).count{
        case 0: return 0
        default: return scores.map{$0.auto.total().double()}.mean()
        }
    }
    func avgTeleScore() -> Double {
        switch scores.map({$0.val()}).count{
        case 0: return 0
        default: return scores.map{$0.tele.total().double()}.mean()
        }
    }
    func avgEndScore() -> Double {
        switch scores.map({$0.val()}).count{
        case 0: return 0
        default: return scores.map{$0.endgame.total().double()}.mean()
        }
    }
    func bestScore() -> Double {
       scores.compactMap{ Double($0.val()) }.max() ?? 0
    }
    func bestAutoScore() -> Double {
        scores.compactMap { $0.auto.total().double() }.max() ?? 0
    }
    func bestTeleScore() -> Double {
        scores.compactMap { $0.tele.total().double() }.max() ?? 0
    }
    func bestEndScore() -> Double {
        scores.compactMap { $0.endgame.total().double() }.max() ?? 0
    }
    func MAD() -> Double{
        scores.map {$0.val().double()}.MAD()
    }
    func autoMAD() -> Double{
        scores.map {$0.auto.total().double()}.MAD()
    }
    func teleMAD() -> Double{
        scores.map {$0.tele.total().double()}.MAD()
    }
    func endMAD() -> Double{
        scores.map {$0.endgame.total().double()}.MAD()
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
        red.0.scores.append(Score(id))
        red.1.scores.append(Score(id))
        blue.0.scores.append(Score(id))
        blue.1.scores.append(Score(id))
        self.red = red
        self.blue = blue
    }
    
    func score() -> String{
        let r1 = red.0.scores.reduce(Score()){ $1.id == self.id ? $1 : $0 }
        let r2 = red.1.scores.reduce(Score()){ $1.id == self.id ? $1 : $0 }
        let b1 = blue.0.scores.reduce(Score()){ $1.id == self.id ? $1 : $0 }
        let b2 = blue.0.scores.reduce(Score()){ $1.id == self.id ? $1 : $0 }

        return "\((r1.val()) + (r2.val())) - \((b1.val()) + (b2.val()))"
        
    }
}

class Data: ObservableObject{
    @Published var teams: [Team]
    @Published var matches: [Match]
    @Published var user: Team?
    init(){
        
        teams = []
        matches = []
            //.publisher
        user = .none
    }
    
    func setUser(_ t: Team){
        addTeam(t)
        user = t
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
            .min() ?? 1
    }
    func lowestTeleMAD() -> Double {
        teams
            .map { $0.teleMAD() }
            .min() ?? 1
    }
    func lowestAutoMAD() -> Double {
        teams
            .map { $0.autoMAD() }
            .min() ?? 1
    }
    func lowestEndMAD() -> Double {
        teams
            .map { $0.endMAD() }
            .min() ?? 1
    }
}

