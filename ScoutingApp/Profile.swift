//
//  Profile.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 12/24/20.
//

import SwiftUI

struct Profile: View {
    @ObservedObject var dataModel: DataModel
    var body: some View {
        VStack {
            Image("LoadingScreen2")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .overlay(Circle().stroke())
                
            Text(dataModel.user?.name ?? "Anonymous")
            Circle()
                .foregroundColor(.blue)
            Spacer()
        }
        .padding()
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(dataModel: DataModel())
    }
}
