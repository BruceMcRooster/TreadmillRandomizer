//
//  Ring.swift
//  TreadmillRandomizer
//
//  Created by Evan on 11/27/23.
//

import SwiftUI

struct Ring: View {
    
    let lineWidth: CGFloat
    let backgroundColor: Color
    let foregroundColor: Color
    let percentage: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RingShape()
                    .stroke(style: StrokeStyle(lineWidth: lineWidth))
                    .fill(backgroundColor)
                RingShape(percent: percentage)
                    .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .fill(foregroundColor)
            }
            .padding(lineWidth / 2)
            .animation(.easeIn, value: percentage)
        }
    }
}

#Preview {
    PreviewContainer()
}

fileprivate struct PreviewContainer: View {
    
    @State private var percentage = 30.0
    
    var body: some View {
        Ring(lineWidth: 50, backgroundColor: Color.blue.opacity(0.2), foregroundColor: Color.blue, percentage: percentage)
            .frame(width: 300, height: 300)
            .onTapGesture {
                percentage = 80
            }
    }
}
