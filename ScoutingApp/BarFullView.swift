//
//  BarFullView.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 10/28/20.
//

import SwiftUI
extension Array where Element == Double{
    func percentIncrease() -> Int{
        switch self.count{
        case 0: return 0
        case 1: return 0
        default: return Int(((self[self.count - 1] - self[self.count - 2])/self[self.count - 2]) * 100)
        }
    }
}
struct BarFullView: View {
    var points: [Double]
    var barGraph: BarGraph
    var cards: [AnyView]
    init(points: [Double], barGraph: BarGraph, cards: @escaping () -> [AnyView]){
        self.points = points
        self.barGraph = barGraph
        self.barGraph.clickable = false
        self.cards = cards()
    }
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    CardView(){
                        barGraph
                            .format()
                    }.frame(height: 240)
                    if(points.count > 1){
                        //LineChartView(data: points, title: "Timeline", rateValue: points.percentIncrease())
                    }
                    else{
                        Text("")
                    }
                }
                ForEach(0 ..< cards.count){ n in
                    CardView(){
                        cards[n]
                    }
                }
            }
        }
    }
}

struct BarFullView_Previews: PreviewProvider {
    static var previews: some View {
        BarFullView(points: [9], barGraph: BarGraph(name: "Auto Scores", val: 2, max: 10)){[
            AnyView(Text("Hello!")),
            AnyView(Text("Hello!")),
            AnyView(Text("Hello!"))
        ]}
    }
}
