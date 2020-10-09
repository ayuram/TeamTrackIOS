//
//  ThemedButton.swift
//  ProCrast
//
//  Created by Ayush Raman on 8/6/20.
//  Copyright © 2020 Answer Key. All rights reserved.
//

import SwiftUI

struct ThemedButton: View {
    var text: String = "Button"
    var buttonColor: Color = Color.green
    var textColor: Color = Color.white
    var action: () -> Void
    var body: some View {
        HStack {
            Spacer()
            Button(action: action) {
                Text(text).font(.system(size: 12))
                    //.font(.system(.headline, design: .rounded))
                
                    .font(.system(.headline))
                    .fontWeight(.bold)
                    .foregroundColor(textColor)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: 90.0, height: 50.0)
            }
            .background(buttonColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
                //.overlay(Capsule().stroke(Color.black, lineWidth: 1.0))
                .shadow(radius: 2.0)
                
            Spacer()
        }
    }
}

struct ThemedButton_Previews: PreviewProvider {
    static var previews: some View {
        ThemedButton(text: "Button"){}
    }
}
