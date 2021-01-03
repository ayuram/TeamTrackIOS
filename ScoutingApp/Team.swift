//
//  Team.swift
//  FTCscorer
//
//  Created by Ayush Raman on 8/23/20.
//  Copyright © 2020 MSET Cuttlefish. All rights reserved.
//

import Foundation
extension Int{
    func double() -> Double {
        Double(self)
    }
}
enum Dice: Int, Codable{
    case one
    case two
    case three
    func maxScore() -> Int{
        switch self {
        case .one:
            return 104
        case .two:
            return 116
        case .three:
            return 152
        }
    }
    func stackHeight() -> Int {
        switch self {
        case .one: return 0
        case .two: return 1
        case .three: return 4
        }
    }
}
struct AutoScore: Codable, Equatable {
    var wobbleGoals: Int = 0
    var lowGoals: Int = 0
    var midGoals: Int = 0
    var hiGoals: Int = 0
    var pwrShots: Int = 0
    var navigated: Bool = false
    func total() -> Int {
        wobbleGoals * 15 + lowGoals * 3 + midGoals * 6 + hiGoals * 12 + pwrShots * 15 + (navigated ? 5 : 0)
    }
}
struct TeleScore: Codable, Equatable {
    var lowGoals: Int = 0
    var midGoals: Int = 0
    var hiGoals: Int = 0
    func total() -> Int{
        lowGoals * 2 + midGoals * 4 + hiGoals * 6
    }
}
struct EndgameScore: Codable, Equatable {
    var pwrShots: Int = 0
    var wobbleGoalsinDrop: Int = 0
    var wobbleGoalsinStart: Int = 0
    var ringsOnWobble: Int = 0
    func total() -> Int {
        pwrShots * 15 + wobbleGoalsinDrop * 20 + wobbleGoalsinStart * 5 + ringsOnWobble * 5
    }
}
class Score: ObservableObject, Codable{
    var id: UUID
    var scoringCase: Dice = .one
    @Published var auto = AutoScore()
    @Published var tele = TeleScore()
    @Published var endgame = EndgameScore()
    enum CodingKeys: CodingKey {
        case id
        case scoringCase
        case auto
        case tele
        case endgame
    }
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        scoringCase = try container.decode(Dice.self, forKey: .scoringCase)
        id = try container.decode(UUID.self, forKey: .id)
        auto = try container.decode(AutoScore.self, forKey: .auto)
        tele = try container.decode(TeleScore.self, forKey: .tele)
        endgame = try container.decode(EndgameScore.self, forKey: .endgame)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(auto, forKey: .auto)
        try container.encode(tele, forKey: .tele)
        try container.encode(endgame, forKey: .endgame)
        try container.encode(scoringCase, forKey: .scoringCase)
    }
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
        return auto.total() + tele.total() + endgame.total()
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
extension Array where Element == Score {
    func find(_ id: UUID) -> Score{
        self.reduce(Score()){ $1.id == id ? $1 : $0}
    }
    mutating func addScore(_ s: Score){
        var bool: Bool = false
        for score in self{
            if(score.id == s.id){
                bool = true
            }
        }
        if(!bool){
            self.append(s)
        }
    }
}
extension Array where Element == Team{
    func findByNumber(_ number: String) -> Team{
        return self.reduce(Team("000", "????")){ $1.number == number ? $1 : $0}
    }
}
class Team: ObservableObject, Identifiable, Codable, Equatable{
    var number: String
    var name: String
    @Published var scores: [Score]
    var type: EventType = .local
    var gpscore: Double = 10
    init(_ n: String,_ s: String){
        number = n
        name = s
        scores = []
        type = .local
    }
    init(){
        number = ""
        name = ""
        scores = []
        type = .local
    }
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        scores = try container.decode([Score].self, forKey: .scores)
        name = try container.decode(String.self, forKey: .name)
        number = try container.decode(String.self, forKey: .number)
        //print(scores)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(scores, forKey: .scores)
        try container.encode(name, forKey: .name)
        try container.encode(number, forKey: .number)
    }
    enum CodingKeys: String, CodingKey{
        case number
        case name
        case scores
        case type
    }
    func avgScore() -> Double{
        switch scores.map({$0.val()}).count{
        case 0: return 0
        default: return scores.map{Double($0.val())}.mean()
        }
    }
    func avgAutoScore(dice: Dice?) -> Double{
        let arr = dice != .none ? scores.filter{$0.scoringCase == dice} : scores
        switch arr.count{
        case 0: return 0
        default: return arr.map{$0.auto.total().double()}.mean()
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
    func bestAutoScore(dice: Dice?) -> Double {
        let arr = dice != .none ? scores.filter{$0.scoringCase == dice} : scores
        return arr.compactMap { $0.auto.total().double() }.max() ?? 0
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
    func autoMAD(dice: Dice?) -> Double{
        let arr = dice != .none ? scores.filter{$0.scoringCase == dice} : scores
        return arr.map {$0.auto.total().double()}.MAD()
    }
    func teleMAD() -> Double{
        scores.map {$0.tele.total().double()}.MAD()
    }
    func endMAD() -> Double{
        scores.map {$0.endgame.total().double()}.MAD()
    }
    
    static func < (_ lhs: Team, _ rhs: Team) -> Bool{
        Int(lhs.number) ?? 0 < Int(rhs.number) ?? 0
    }
    static func > (_ lhs: Team, _ rhs: Team) -> Bool{
        Int(lhs.number) ?? 0 > Int(rhs.number) ?? 0
    }
    static func == (_ lhs: Team, _ rhs: Team) -> Bool {
        lhs.number == rhs.number
    }
}
typealias Side = (Team, Team)
class Match: Identifiable, ObservableObject, Codable{
    var id: UUID = UUID()
    @Published var red: Side = (Team("", ""), Team("", ""))
    @Published var blue: Side = (Team("", ""), Team("", ""))
    @Published var scoringCase: Dice = .one
    var type: EventType = .local
    init(red: Side, blue: Side){
        id = UUID()
        type = .local
        self.red = red
        self.blue = blue
        self.red.0.scores.addScore(Score(id))
        self.red.1.scores.addScore(Score(id))
        self.blue.0.scores.addScore(Score(id))
        self.blue.1.scores.addScore(Score(id))
    }
    init(red: Side, blue: Side, type: EventType){
        self.type = type
        id = UUID()
        self.red = red
        self.blue = blue
        self.red.0.scores.addScore(Score(id))
        self.red.1.scores.addScore(Score(id))
        self.blue.0.scores.addScore(Score(id))
        self.blue.1.scores.addScore(Score(id))
    }
    init(team: Team){
        type = .virtual
        id = UUID()
        self.red.0 = team
        self.red.1 = Team("", "")
        self.blue.0 = Team("", "")
        self.blue.1 = Team("", "")
        self.red.0.scores.addScore(Score(id))
        self.red.1.scores.addScore(Score(id))
        self.blue.0.scores.addScore(Score(id))
        self.blue.1.scores.addScore(Score(id))
    }
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        scoringCase = try container.decode(Dice.self, forKey: .scoringCase)
        red.0 = try container.decode(Team.self, forKey: .red0)
        red.1 = try container.decode(Team.self, forKey: .red1)
        blue.0 = try container.decode(Team.self, forKey: .blue0)
        blue.1 = try container.decode(Team.self, forKey: .blue1)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(scoringCase, forKey: .scoringCase)
        try container.encode(red.0, forKey: .red0)
        try container.encode(blue.0, forKey: .blue0)
        try container.encode(blue.1, forKey: .blue1)
        try container.encode(red.1, forKey: .red1)
    }
    enum CodingKeys: CodingKey{
        case id
        case scoringCase
        case red0, red1
        case blue0, blue1
    }
    func allianceTotal(of side: Side) -> Int{
        side.0.scores.find(id).val() + side.1.scores.find(id).val()
    }
    func score() -> String{
        let r1 = red.0.scores.reduce(Score()){ $1.id == self.id ? $1 : $0 }
        let r2 = red.1.scores.reduce(Score()){ $1.id == self.id ? $1 : $0 }
        let b1 = blue.0.scores.reduce(Score()){ $1.id == self.id ? $1 : $0 }
        let b2 = blue.1.scores.reduce(Score()){ $1.id == self.id ? $1 : $0 }
        
        return "\((r1.val() ) + (r2.val() )) - \((b1.val() ) + (b2.val() ))"
        
    }
    func changeCase(){
        red.0.scores.find(id).scoringCase = scoringCase
        red.1.scores.find(id).scoringCase = scoringCase
        blue.0.scores.find(id).scoringCase = scoringCase
        blue.1.scores.find(id).scoringCase = scoringCase
    }
    func total() -> Int{
        let r1 = red.0.scores.reduce(Score()){ $1.id == self.id ? $1 : $0 }.val()
        let r2 = red.1.scores.reduce(Score()){ $1.id == self.id ? $1 : $0 }.val()
        let b1 = blue.0.scores.reduce(Score()){ $1.id == self.id ? $1 : $0 }.val()
        let b2 = blue.1.scores.reduce(Score()){ $1.id == self.id ? $1 : $0 }.val()
        
        return r1 + r2 + b1 + b2
    }
}
class Event: ObservableObject, Codable, Identifiable{
    @Published var teams: [Team]
    @Published var matches: [Match]
    let name: String
    var type: EventType
    init(_ name: String, type: EventType) {
        self.name = name
        teams = []
        matches = []
        self.type = type
        switchType(to: type)
    }
    init(){
        name = "FIRST Event"
        teams = []
        matches = []
        type = .local
    }
    required init(from decoder: Decoder) throws{
        type = .virtual
        let container = try decoder.container(keyedBy: CodingKeys.self)
        teams = try container.decode([Team].self, forKey: .teams)
        matches = try container.decode([Match].self, forKey: .matches)
        name = try container.decode(String.self, forKey: .name)
    }
    enum CodingKeys: String, CodingKey{
        case teams
        case matches
        case name
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(teams, forKey: .teams)
        try container.encode(matches, forKey: .matches)
        try container.encode(name, forKey: .name)
    }
    func switchType(to type: EventType){
        self.type = type
        for team in teams {
            team.type = type
        }
        for match in matches {
            match.type = type
        }   
    }
    func bestTeam() -> [Team]?{
        let arr = teams.sorted { $0.avgScore() > $1.avgScore() }[0 ... 3]
        return Array(arr)
    }
    func addTeam(_ team: Team){
        var bool: Bool = false
        for t in teams{
            if(t.number == team.number){
                bool = true
            }
        }
        
        if(!bool){
            for match in matches {
                if match.red.0.number == team.number {
                    team.scores.addScore(match.red.0.scores.find(match.id))
                    match.red.0 = team
                } else if match.red.1.number == team.number {
                    team.scores.addScore(match.red.1.scores.find(match.id))
                    match.red.1 = team
                } else if match.blue.0.number == team.number {
                    team.scores.addScore(match.blue.0.scores.find(match.id))
                    match.blue.0 = team
                } else if match.blue.1.number == team.number {
                    team.scores.addScore(match.blue.1.scores.find(match.id))
                    match.blue.1 = team
                }
            }
            teams.append(team)
        }
        sortTeams()
    }
    func addMatch(_ match: Match){
        var bool: Bool = false
        for m in matches{
            if(m.id == match.id){
                bool = true
            }
        }
        if(!bool){
            matches.append(match)
        }
    }
    func allianceScores(of team: Team) -> [Int]{
        let arr = matches.filter { $0.red.0 == team || $0.red.1 == team || $0.blue.0 == team || $0.blue.1 == team }
        return arr.map { match in
            var total: Int = 0
            if match.red.0 == team || match.red.1 == team {
                total += match.allianceTotal(of: match.red)
            } else if match.blue.0 == team || match.blue.1 == team {
                total += match.allianceTotal(of: match.blue)
            }
            return total
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
    func maxAutoScore(dice: Dice?) -> Double {
        teams
            .map { $0.bestAutoScore(dice: dice) }
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
    func lowestAutoMAD(dice: Dice?) -> Double {
        teams
            .map { $0.autoMAD(dice: dice) }
            .min() ?? 1
    }
    func lowestEndMAD() -> Double {
        teams
            .map { $0.endMAD() }
            .min() ?? 1
    }
}
class DataModel: ObservableObject{
    @Published var localEvents: [Event]
    @Published var virtualEvents: [Event]
    @Published var liveEvents: [Event]
    private func disenfranchise(){
        var teams = [Team]()
        if let data = UserDefaults.standard.data(forKey: "Teams"){
            if let decoded = try? JSONDecoder().decode([Team].self, from: data){
                teams = decoded
                print("teams decoded \(teams)")
            }
        }
        var matches = [Match]()
        if let d = UserDefaults.standard.data(forKey: "Matches"){
            if let decoded = try? JSONDecoder().decode([Match].self, from: d){
                for match in decoded{
                    match.red.0 = teams.findByNumber(match.red.0.number )
                    match.red.1 = teams.findByNumber(match.red.1.number )
                    match.blue.0 = teams.findByNumber(match.blue.0.number )
                    match.blue.1 = teams.findByNumber(match.blue.1.number )
                }
                matches = decoded
            }
        }
        localEvents.append(Event())
        localEvents.last?.teams.append(contentsOf: teams)
        localEvents.last?.matches.append(contentsOf: matches)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(false) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "Teams")
        }
        if let encoded = try? encoder.encode(false){
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "Matches")
        }
    }
    init(){
        localEvents = []
        virtualEvents = []
        liveEvents = []
        disenfranchise()
        print("initializing")
        if let data = UserDefaults.standard.data(forKey: "LocalEvents"){
            if let decoded = try? JSONDecoder().decode([Event].self, from: data){
                localEvents = decoded
                print("localEvent \(localEvents)")
                for event in localEvents{
                    for match in event.matches{
                        match.red.0 = event.teams.findByNumber(match.red.0.number)
                        match.red.1 = event.teams.findByNumber(match.red.1.number)
                        match.blue.0 = event.teams.findByNumber(match.blue.0.number)
                        match.blue.1 = event.teams.findByNumber(match.blue.1.number)
                    }
                }
            }
        }
        
        if let data = UserDefaults.standard.data(forKey: "Virtual"){
            if let decoded = try? JSONDecoder().decode([Event].self, from: data){
                virtualEvents = decoded
                print(virtualEvents)
                for event in virtualEvents{
                    for match in event.matches{
                        match.red.0 = event.teams.findByNumber(match.red.0.number)
                        match.red.1 = Team("", "")
                        match.blue.0 = Team("", "")
                        match.blue.1 = Team("", "")
                    }
                }
            }
            
        }
        setTypes()
    }
    func setTypes() {
        for event in localEvents {
            event.switchType(to: .local)
        }
        for event in virtualEvents {
            event.switchType(to: .virtual)
        }
        for event in liveEvents {
            event.switchType(to: .live)
        }
    }
    func saveEvents(){
        setTypes()
        let encoder = JSONEncoder()
        if let encoded = try? JSONEncoder().encode(localEvents) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "LocalEvents")
        }
       
        if let encoded = try? encoder.encode(virtualEvents) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "Virtual")
            print(type(of: type(of: encoded)))
        }
    }
}
enum EventType {
    case local
    case virtual
    case live
}
