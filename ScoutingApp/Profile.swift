//
//  Profile.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 12/24/20.
//

import SwiftUI

struct Profile: View {
    @EnvironmentObject var dataModel: DataModel
    @State var logOut = false
    var body: some View {
        
            VStack {
                Image("LoadingScreen2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .overlay(Circle().stroke())
                Text(dataModel.user?.name ?? "Anonymous")
                    .font(.title)
                HStack{
                    Circle()
                        .foregroundColor(.green)
                        .rotationEffect(Angle(degrees: 90))
                    VStack(){
                        Text("What is Trust?")
                            .font(.headline)
                        Text("When creating a live event, feeding accurate scores into the match editor will help boost your trust score. Giving other teams positive ratings will also slightly raise your score")
                            .font(.caption)
                    }
                }
                .padding()
                
                Spacer()
            }
            .navigationBarTitle("Profile")
            .navigationBarItems(trailing: Button(action: {
                logOut.toggle()
            }, label: {
                Text("Sign Out")
                    .padding(7)
                    .foregroundColor(.red)
                    .background(Color(.systemGray2))
                    .clipShape(Capsule())
                
            })
            .buttonStyle(PlainButtonStyle()))
            .alert(isPresented: $logOut, content: {
                Alert(title: Text("Log Out"), message: Text("Are you sure?"), primaryButton: .cancel(){dataModel.setUser(name: "Elmo")}, secondaryButton: .destructive(Text("Confirm")){dataModel.setUser(name: "Chris")})
            })
        }
    
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
            .environmentObject(DataModel())
            .preferredColorScheme(.dark)
    }
}
