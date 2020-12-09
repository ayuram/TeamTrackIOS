//
//  EventView.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 12/5/20.
//

import SwiftUI

struct EventView: View {
    let event: Event
    var body: some View {
        TabView{
          TeamList()
            .tabItem {
                Image(systemName: "person.3.fill")
                Text("Teams")
            }
            MatchList()
            .tabItem {
                Image(systemName: "sportscourt.fill")
                Text("Matches")
            }
        }.environmentObject(event)
    }
}
struct testView: View {
    enum Tabs{
        case teams, matches
    }
    let event: Event
    @State var selectedTab = Tabs.teams
    @State var bool = false
    let defaultAnimation = Animation.interactiveSpring(response: 0.3, dampingFraction: 0.6, blendDuration: 1)
    var body: some View {
        ZStack{
            VStack{
            viewSelect()
                .environmentObject(event)
                Color.green
                    .edgesIgnoringSafeArea(.all)
                    .frame(height: 80)
                    .shadow(radius: 5)
            }
            VStack{
                Spacer()
                ZStack{
//                    Capsule()
//                        .fill(Color.green.opacity(0.8))
//                        .frame(width: 300, height: 80)
//                        .shadow(radius: check(.teams) ? 5 : 0)
                    Color.green
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: 80)
                        .shadow(radius: 5)
                HStack{
                    Spacer()
                    Button(action: {
                        selectedTab = .teams
                        bool = true
                    }, label: {
                        VStack{
                            Image(systemName: "person.3.fill")
                            Text("Teams")
                                .font(.caption)
                        }
                        .frame(width: check(.teams) ? 70 : 60, height: check(.teams) ? 70 : 60)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: check(.teams) ? 5 : 0)
                        .offset(x: check(.teams) ? 25 : 0, y: check(.teams) ? -25 : 0)
                        .animation(defaultAnimation)
                    })
                    Spacer()
                    Spacer()
                    Button(action: {
                        selectedTab = .matches
                        bool = true
                    }, label: {
                        VStack{
                            Image(systemName: "sportscourt.fill")
                            Text("Matches")
                                .font(.caption)
                        }
                        .frame(width: check(.matches) ? 70 : 60, height: check(.matches) ? 70 : 60)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: check(.matches) ? 5 : 0)
                        .offset(x: check(.matches) ? -25 : 0, y: check(.matches) ? -25 : 0)
                        .animation(defaultAnimation)
                    })
                    Spacer()
                }
                
                
                }
            }
        }
    }
    func viewSelect() -> some View{
        switch selectedTab{
        case .teams: return TeamList().format()
        case .matches: return MatchList().format()
        }
    }
    func check(_ tab: Tabs) -> Bool{
        tab == selectedTab && bool
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(event: Event())
    }
}
struct newPrev: PreviewProvider {
    static var previews: some View {
        testView(event: Event())
    }
}
