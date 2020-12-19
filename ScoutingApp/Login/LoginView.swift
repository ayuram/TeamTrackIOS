//
//  LoginView.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 12/13/20.
//

import SwiftUI
import GoogleSignIn
struct LoginView: View {
    @State var success = false
    @State var email = ""
    @State var password = ""
    var body: some View {
        ZStack(alignment: .top){
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            Image("LoadingScreen2")
                .resizable()
                .scaledToFit()
                .padding(.top)
            VStack(){
                Spacer()
                    .frame(height: 450)
                VStack{
                    HStack{
                        Image(systemName: "person.circle.fill")
                        TextField("Email", text: $email)
                            .disableAutocorrection(true)
                            .keyboardType(.emailAddress)
                    }
                    Divider()
                    HStack{
                        Image(systemName: "lock.circle.fill")
                        SecureField("Password", text: $password)
                            .disableAutocorrection(true)
                    }
                }
                .padding()
                .frame(width: 300, height: 100, alignment: .center)
                .background(Color("background"))
                .clipShape(Capsule())
                .shadow(color: success ? .green : .red, radius: success ? 3 : 10)
                .animation(.default)
                HStack{
                    ThemedButton(text: "Register", buttonColor: .yellow, width: 150){
                    }
                    ThemedButton(text: "Login", width: 150){
                        
                    }
                }
                GSignIn()
                    .frame(height: 60)
            }
            
        }
    }
}
struct GSignIn: UIViewRepresentable{
    func makeUIView(context: Context) -> GIDSignInButton {
        let button = GIDSignInButton()
        button.colorScheme = .light
        button.style = .wide
        return button
    }
    func updateUIView(_ uiView: GIDSignInButton, context: Context) {
        
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
