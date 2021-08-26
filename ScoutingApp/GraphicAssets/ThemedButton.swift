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
            Button(action: action) {
                Text(text).font(.system(size: 12))
                    //.font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(textColor)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: 90.0, height: 50.0)
            }
            //.background(buttonColor)
            .background(buttonColor.opacity(0.8))
            .opacity(1)
        .clipShape(RoundedRectangle(cornerRadius: 6))
                //.overlay(Capsule().stroke(Color.black, lineWidth: 1.0))
            .shadow(radius: 8.0)
    }
}

struct ThemedButton_Previews: PreviewProvider {
    static var previews: some View {
        ThemedButton(text: "Click Me"){}
    }
}
