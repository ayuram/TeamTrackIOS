//
//  LineGraph.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 11/9/20.
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
struct LineChart: View{
    var data : [CGFloat] = []
    var color = Color.green
    @State var animateChart = false
    var body: some View{
        ZStack{
            HStack{
                VStack{
                    Text("\(data.max() ?? 0, specifier: "%.0f")")
                    .bold()
                        Spacer()
                    Text("\(data.min() ?? 0, specifier: "%.0f")").bold()
                    
                }
                LineGraph(data.normalized)
                    .trim(to: animateChart ? 1 : 0)
                    .stroke(color, lineWidth: 3)
                    .onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                            self.animateChart = true
                        }
                    })
                        .shadow(color: color, radius: 15)
                    .shadow(color: color, radius: 15)
                    //.shadow(color: color, radius: 15)
                    .animation(.easeInOut(duration: 1.5))
                    .border(Color("text"))
            }
        }
    }
    
}

struct Window_Previews: PreviewProvider{
    static var previews: some View {
        LineChart(data: [1, 3, 4, 2, 1, 7, 3])
            .frame(height: 380)
    }
}

