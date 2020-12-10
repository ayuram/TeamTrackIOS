//
//  EventView.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 12/5/20.
//

import SwiftUI

struct EventView: View {
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
                tabSelect()
                    .environmentObject(event)
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(Color.green)
                    .frame(height: 80)
                    .shadow(radius: 5)
            }
            VStack{
                Spacer()
                ZStack{
                    HStack{
                        Spacer()
                        Button(action: {
                            selectedTab = .teams
                            bool = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                                bool = false
                            }
                        }, label: {
                            VStack{
                                Image(systemName: "person.3.fill")
                                Text("Teams")
                                    .font(.caption)
                            }
                            .frame(width: check(.teams) ? 70 : 60, height: check(.teams) ? 70 : 60)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: absCheck(.teams) ? .accentColor : .clear, radius: absCheck(.teams) ? 5 : 0)
                            .shadow(color: absCheck(.teams) ? .accentColor : .clear, radius: absCheck(.teams) ? 5 : 0)
                            .offset(y: check(.teams) ? -25 : -10)
                            .animation(defaultAnimation)
                        })
                        Spacer()
                        Spacer()
                        Button(action: {
                            selectedTab = .matches
                            bool = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                                bool = false
                            }
                        }, label: {
                            VStack{
                                Image(systemName: "sportscourt.fill")
                                Text("Matches")
                                    .font(.caption)
                            }
                            .frame(width: check(.matches) ? 70 : 60, height: check(.matches) ? 70 : 60)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: absCheck(.matches) ? .accentColor : .clear, radius: absCheck(.matches) ? 5 : 0)
                            .shadow(color: absCheck(.matches) ? .accentColor : .clear, radius: absCheck(.matches) ? 5 : 0)
                            .offset(y: check(.matches) ? -25 : -10)
                            .animation(defaultAnimation)
                        })
                        Spacer()
                    }
                }
            }
        }
    }
    
    func tabSelect() -> some View{
        switch selectedTab{
        case .teams: return TeamList().format()
        case .matches: return MatchList().format()
        }
    }
    func check(_ tab: Tabs) -> Bool{
        tab == selectedTab && bool
    }
    func absCheck(_ tab: Tabs) -> Bool{
        tab == selectedTab
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(event: Event())
    }
}
