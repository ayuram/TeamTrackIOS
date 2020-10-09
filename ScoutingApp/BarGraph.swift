//
//  BarGraph.swift
//  FTCscorer
//
//  Created by Ayush Raman on 10/6/20.
//  Copyright © 2020 MSET Cuttlefish. All rights reserved.
//

import SwiftUI

struct BarGraph: View {
    var width: CGFloat = 30
    var height: CGFloat = 100
    var name: String
    var val: Double
    var max: Double
    var flip: Bool = false
    var body: some View {
        choice()
    }
    func choice() -> some View{
        max >= 1 ? AnyView(normal()) : AnyView(abnormal())
    }
    func normal() -> some View{
        NavigationLink(destination: Text("Hello")){
            VStack{
                Text(name)
                    .font(.caption)
                ZStack(alignment: .bottom){
                    Capsule().frame(width: width, height: height)
                        .foregroundColor(.black)
                    Capsule().frame(width: width, height: height * CGFloat((val)/max))
                        .foregroundColor(color())
                }
                (flip ? Text("\(Int(max))") : Text("\(Int(val)) pts"))
                    .font(.caption)
            }
        }.buttonStyle(PlainButtonStyle())
    }
    func abnormal() -> some View{
        NavigationLink(destination: Text("Hello")){
            VStack{
                Text(name)
                    .font(.caption)
                ZStack(alignment: .bottom){
                    Capsule().frame(width: width, height: height)
                        .foregroundColor(.black)
                    Capsule().frame(width: width, height: height)
                        .foregroundColor(.green)
                }
                Text("\(Int(max)) pts")
                    .font(.caption)
            }
        }.buttonStyle(PlainButtonStyle())
    }
    func color() -> Color{
        if(val/max < Double(height/2)){
            return .red
        }
        else if (val/max < Double(0.75 * height)){
            return .yellow
        }
        else{
            return .green
        }
    }
}

struct BarGraph_Previews: PreviewProvider {
    static var previews: some View {
        BarGraph(name: "OK", val: 1, max: 1.5)
    }
}
