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
    @Published var auto = AutoScore()
    @Published var tele = TeleScore()
    @Published var endgame = EndgameScore()
    enum CodingKeys: CodingKey {
        case id
        case auto
        case tele
        case endgame
    }
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        //print("scores \(id)")
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
        print("i was here")
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
        //print(id)
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
    mutating func addScore(_ s: Score){
        var bool: Bool = false
        self.map {
            if($0.id == s.id){
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
        self.reduce(Team()){ $1.number == number ? $1 : $0}
    }
}
class Team: ObservableObject, Identifiable, Codable {
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
typealias Side = (Team, Team)
class Match: Identifiable, ObservableObject, Codable{
    var id: UUID = UUID()
    @Published var red: Side = (Team("", ""), Team("", ""))
    @Published var blue: Side = (Team("", ""), Team("", ""))
    var type = EventType.local
    init(red: Side, blue: Side){
        id = UUID()
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
    init(_ t: Team){
        type = .virtual
    }
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        //print("matches \(id)")
        red.0 = try container.decode(Team.self, forKey: .red0)
        red.1 = try container.decode(Team.self, forKey: .red1)
        blue.0 = try container.decode(Team.self, forKey: .blue0)
        blue.1 = try container.decode(Team.self, forKey: .blue1)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(red.0, forKey: .red0)
        try container.encode(blue.0, forKey: .blue0)
        try container.encode(blue.1, forKey: .blue1)
        try container.encode(red.1, forKey: .red1)
    }
    enum CodingKeys: CodingKey{
        case id
        case red0, red1
        case blue0, blue1
    }
    func score() -> String{
        let r1 = red.0.scores.reduce(Score()){ $1.id == self.id ? $1 : $0 }
        let r2 = red.1.scores.reduce(Score()){ $1.id == self.id ? $1 : $0 }
        let b1 = blue.0.scores.reduce(Score()){ $1.id == self.id ? $1 : $0 }
        let b2 = blue.0.scores.reduce(Score()){ $1.id == self.id ? $1 : $0 }
        
        return "\((r1.val()) + (r2.val())) - \((b1.val()) + (b2.val()))"
        
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
    }
    init(){
        name = "FIRST Event"
        teams = []
        matches = []
        type = .local
        if let data = UserDefaults.standard.data(forKey: "Teams"){
            if let decoded = try? JSONDecoder().decode([Team].self, from: data){
                teams = decoded
            }
        }
        if let d = UserDefaults.standard.data(forKey: "Matches"){
            if let decoded = try? JSONDecoder().decode([Match].self, from: d){
                for match in decoded{
                    match.red.0 = teams.findByNumber(match.red.0.number)
                    match.red.1 = teams.findByNumber(match.red.1.number)
                    match.blue.0 = teams.findByNumber(match.blue.0.number)
                    match.blue.1 = teams.findByNumber(match.blue.1.number)
                }
                matches = decoded
            }
        }
        
    }
    required init(from decoder: Decoder) throws{
        type = .local
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
        teams.map {
            if($0.number == team.number){
                bool = true
            }
        }
        if(!bool){
            teams.append(team)
            saveTeams()
        }
        sortTeams()
    }
    func saveTeams(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(teams) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "Teams")
        }
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
            saveMatches()
        }
    }
    func saveMatches(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(matches) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "Matches")
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
class VirtualEvent: ObservableObject, Codable, Identifiable{
    @Published var teams: [Team]
    @Published var matches: [VirtualMatch]
    let name: String
    init(){
        name = "FIRST Event"
        teams = []
        matches = []
    }
    init(_ name: String){
        self.name = name
        teams = []
        matches = []
    }
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        teams = try container.decode([Team].self, forKey: .teams)
        matches = try container.decode([VirtualMatch].self, forKey: .matches)
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
}
class VirtualMatch: ObservableObject, Codable{
    var team: Team
    let id: UUID
}
class DataModel: ObservableObject{
    @Published var localEvents: [Event]
    @Published var virtualEvents: [VirtualEvent]
    @Published var liveEvents: [Event]
    init(local: [Event], virtual: [VirtualEvent], live: [Event]){
        localEvents = local
        virtualEvents = virtual
        liveEvents = live
        if let data = UserDefaults.standard.data(forKey: "LocalEvents"){
            if let decoded = try? JSONDecoder().decode([Event].self, from: data){
                localEvents = decoded
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
        if let d = UserDefaults.standard.data(forKey: "VirtualEvents"){
            if let decoded = try? JSONDecoder().decode([VirtualEvent].self, from: d){
                virtualEvents = decoded
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
        setTypes()
        
    }
    private func setTypes() {
        for event in localEvents {
            for team in event.teams {
                team.type = .local
            }
        }
        for event in virtualEvents {
            for team in event.teams {
                team.type = .virtual
            }
        }
        for event in liveEvents {
            for team in event.teams {
                team.type = .live
            }
        }
    }
    init(){
        localEvents = []
        virtualEvents = []
        liveEvents = []
        
    }
    func saveEvents(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(localEvents) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "LocalEvents")
        }
        if let encoded = try? encoder.encode(virtualEvents) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "VirtualEvents")
        }
    }
}
enum EventType {
    case local
    case virtual
    case live
}
