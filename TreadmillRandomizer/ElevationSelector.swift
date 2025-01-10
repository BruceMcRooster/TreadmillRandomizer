//
//  ElevationSelector.swift
//  TreadmillRandomizer
//
//  Created by Evan on 11/26/23.
//

import SwiftUI
import SwiftData

struct ElevationSelector: View {
    
    @Binding var min: Double
    @Binding var max: Double
    
    var body: some View {
        Section(header: Text("Elevation")) {
            TextField(
                "Minimum Elevation",
                value: $min,
                format: .number
            )
            .keyboardType(.decimalPad)
            TextField(
                "Maximum Elevation",
                value: $max,
                format: .number
            )
            .keyboardType(.decimalPad)
        }
        .onChange(of: min) {
            min = confineElevation((0...12).coerce(min))
        }
        .onChange(of: max) {
            max = confineElevation((0...12).coerce(max))
        }
    }
}

#Preview {
    PreviewContainer()
}

fileprivate struct PreviewContainer: View {
    @State var min = 0.0
    @State var max = 2.0
    
    var body: some View {
        Form {
            ElevationSelector(min: $min, max: $max)
        }
    }
}

public func confineElevation(_ input: Double) -> Double {
    return (input * 2).rounded() / 2
}
