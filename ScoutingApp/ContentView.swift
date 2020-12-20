//
//  ContentView.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 10/9/20.
//

import SwiftUI
struct ContentView: View {
    @ObservedObject var dataModel: DataModel = DataModel()
    enum Tabs{
        case events, profile
    }
    @State var selectedTab = Tabs.events
    @State var tabBool = false
    let defaultAnimation = Animation.interactiveSpring(response: 0.3, dampingFraction: 0.6, blendDuration: 1)
    init(){
        UITableView.appearance().backgroundColor = UIColor(Color("background"))
    }
    var body: some View {
        ZStack{
            EventsList()
                .environmentObject(dataModel)
            ZStack{
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(Color.green)
                    .frame(height: 80)
                    .shadow(radius: 5)
                HStack{
                    Spacer()
                    Button(action: {
                        withAnimation(.linear){
                            selectedTab = .events
                        }
                        tabBool = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                            tabBool = false
                        }
                    }, label: {
                        VStack{
                            Image(systemName: "rectangle.grid.1x2.fill")
                            Text("Events")
                                .font(.caption)
                        }
                        .frame(width: check(.events) ? 70 : 60, height: check(.events) ? 70 : 60)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: absCheck(.events) ? .accentColor : .clear, radius: absCheck(.events) ? 5 : 0)
                        .shadow(color: absCheck(.events) ? .accentColor : .clear, radius: absCheck(.events) ? 5 : 0)
                        .offset(y: check(.events) ? -25 : 0)
                        .animation(defaultAnimation)
                    })
                    Spacer()
                    Spacer()
                    Button(action: {
                        withAnimation(.linear){
                            selectedTab = .profile
                        }
                        tabBool = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                            tabBool = false
                        }
                    }, label: {
                        VStack{
                            Image(systemName: "person.crop.circle.fill")
                            Text("Profile")
                                .font(.caption)
                        }
                        .frame(width: check(.profile) ? 70 : 60, height: check(.profile) ? 70 : 60)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: absCheck(.profile) ? .accentColor : .clear, radius: absCheck(.profile) ? 5 : 0)
                        .shadow(color: absCheck(.profile) ? .accentColor : .clear, radius: absCheck(.profile) ? 5 : 0)
                        .offset(y: check(.profile) ? -25 : 0)
                        .animation(defaultAnimation)
                    })
                    Spacer()
                }
            }
            .padding(.bottom)
        }
    }
    func check(_ tab: Tabs) -> Bool{
        tab == selectedTab && tabBool
    }
    func absCheck(_ tab: Tabs) -> Bool{
        tab == selectedTab
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
