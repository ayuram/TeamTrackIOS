//
//  SwiftUIView.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 11/7/20.
//

import SwiftUI
import SwiftUICharts
struct SwiftUIView: View {
    var body: some View {
        VStack{
            Text("Hello World")
            LineView(data: [2, 3, 1, 5, 6, 7])
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
