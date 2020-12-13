//
//  LoginView.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 12/13/20.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
            Image("LoadingScreenUniversal")
                .resizable()
                .scaledToFit()
            VStack {
                Spacer()
                HStack{
                    Text("Hello World!")
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
