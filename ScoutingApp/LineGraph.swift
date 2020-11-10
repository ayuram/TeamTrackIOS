//
//  LineGraph.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 11/9/20.
//

import SwiftUI

//
//  LineGraph.swift
//  ProCrast
//
//  Created by Ayush Raman on 8/9/20.
//  Copyright © 2020 Answer Key. All rights reserved.
//

import SwiftUI

struct LineGraph: Shape {
    
    var dataPoints: [CGFloat] = []
   
    init(_ data: [CGFloat]){
        dataPoints = data
    }
    func path(in rect: CGRect) -> Path{
        func point(at ix: Int) -> CGPoint{
            let point = dataPoints[ix]
            let x = rect.width * CGFloat(ix)/CGFloat(dataPoints.count)
            let y = (1-point) * rect.height
            return CGPoint(x: x, y: y)
        }
        return Path{ p in
            guard dataPoints.count > 1 else { return }
            let start = dataPoints[0]
            p.move(to: CGPoint(x: 0, y: (1 - start) * rect.height))
            for idx in dataPoints.indices {
                p.addLine(to: point(at: idx))
            }
        }
    }
}
struct Line: View{
    var points : [CGFloat] = []
    var body: some View{
        ZStack{
        Rectangle()
            .frame(width: 150, height: 130, alignment: .center)
        
        }
    }
    
}

struct Window_Previews: PreviewProvider{
    static var previews: some View {
        Text("Hello")
    }
}

