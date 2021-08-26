//
//  CardView.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 10/28/20.
//

import SwiftUI

extension View{
    func format() -> AnyView{
        AnyView(self)
    }
    func cardView(_ color: Color = Color("background")) -> CardView{
        CardView(color: color){
           AnyView(self)
        }
    }
}
struct CardView: View {
    var color: Color = Color("background")
    var view: () -> AnyView
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(color)
                .shadow(color: Color("text"), radius: 8)
            view()
        }.frame(height: 240)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(){
            Text("Hello World!")
                .bold()
                .format()
        }
    }
}
