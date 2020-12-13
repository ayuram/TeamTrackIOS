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
            .edgesIgnoringSafeArea(.all)
            VStack{
                Image("LoadingScreen2")
                    .resizable()
                    .scaledToFit()
                    .padding(.top)
                Spacer()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
