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
   // var view: () -> AnyView? = defaultView
    var clickable = false
    @State var sheet = false
    
    var body: some View {
       // print(type(of: view))
        if(clickable){
            return AnyView(NavigationLink(destination: BarFullView(points: [1, 8, 9, 2, 13], barGraph: self){[
                AnyView(Text("Hello"))
            ]}.transition(.scale)){
                choice()
            }.buttonStyle(PlainButtonStyle()))
        }
        else{
            return AnyView(choice())
        }
    }
    func choice() -> some View{
        if(max == 0){
            return AnyView(undefined())
        }
        return (!flip) ? AnyView(normal()) : AnyView(abnormal())
    }
    func normal() -> some View{
        
            VStack{
                Text(name)
                    .font(.caption)
                ZStack(alignment: .bottom){
                    Capsule().frame(width: width, height: height)
                        .foregroundColor(Color("text"))
                    Capsule().frame(width: width, height: height * CGFloat((val)/max))
                        .foregroundColor(color())
                }
                (flip ? Text("\(Int(max))") : Text("\(Int(val))"))
                    .font(.caption)
            }
        
    }
    func undefined() -> some View{
        VStack{
            Text(name)
                .font(.caption)
            ZStack(alignment: .bottom){
                Capsule().frame(width: width, height: height)
                    .foregroundColor(Color("text"))
                //Capsule().frame(width: width, height: height)
                  //  .foregroundColor(color())
            }
            Text("0")
                .font(.caption)
        }
    }
    func abnormal() -> some View{
        
            VStack{
                Text(name)
                    .font(.caption)
                ZStack(alignment: .bottom){
                    Capsule().frame(width: width, height: height)
                        .foregroundColor(Color("text"))
                    Capsule().frame(width: width, height: height * CGFloat(val/max))
                        .foregroundColor(diffColor())
                }
                Text("\(Int(max))")
                    .font(.caption)
            }
       
    }
    func color() -> Color{
        if(val/max < 0.25){
            return .red
        }
        else if (val/max < 0.75){
            return .yellow
        }
        else{
            return .green
        }
    }
    func diffColor() -> Color{
        if(max/val < 0.25){
            return .red
        }
        else if (max/val < 0.75){
            return .yellow
        }
        else{
            return .green
        }
    }
}

struct BarGraph_Previews: PreviewProvider {
    static var previews: some View {
        BarGraph(name: "OK", val: 1, max: 8, flip: true)
    }
}

