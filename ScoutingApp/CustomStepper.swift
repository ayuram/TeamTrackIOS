//
//  CustomStepper.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 11/15/20.
//

import SwiftUI

struct CustomStepper: View {
    var text: String
    var value: Binding<Int>
    var range: ClosedRange<Int> = 0 ... Int.max
    init(_ t: String, value: Binding<Int>, in range: ClosedRange<Int>){
        text = t
        self.value = value
        self.range = range
    }
    var body: some View {
        HStack{
            Text(text)
            Spacer()
            Button(action: {
                if value.wrappedValue > range.min()! {
                    value.wrappedValue -= 1
                    feedback()
                }
            }, label: {
                Image(systemName: "minus.circle.fill")
            })
            Text("\(value.wrappedValue)")
            Button(action: {
                if value.wrappedValue < range.max()! {
                    value.wrappedValue += 1
                    feedback()
                }
            }, label: {
                Image(systemName: "plus.circle.fill")
            })
        }
    }
    func feedback(){
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
