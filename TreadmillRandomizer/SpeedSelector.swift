//
//  SpeedSelector.swift
//  TreadmillRandomizer
//
//  Created by Evan on 11/26/23.
//

import SwiftUI
import SwiftData

struct SpeedSelector: View {
    
    @Binding var min: Double
    @Binding var max: Double
    
    var body: some View {
        Section(header: Text("Speed")) {
            TextField(
                "Minimum Speed",
                value: $min,
                format: .number
            )
            .keyboardType(.decimalPad)
            TextField(
                "Maximum Speed",
                value: $max,
                format: .number
            )
            .keyboardType(.decimalPad)
        }
        .onChange(of: min) {
            if min > max {
                min = max - 0.1
            }
            min = (1.0...12.0).coerce(Double(round(min * 10) / 10))
        }
        .onChange(of: max) {
            if max < min {
                max = min + 0.1
            }
            max = (1.0...12.0).coerce(Double(round(max * 10) / 10))
        }
    }
}

#Preview {
    PreviewContainer()
}

fileprivate struct PreviewContainer: View {
    @State var min = 1.0
    @State var max = 2.0
    
    var body: some View {
        Form {
            SpeedSelector(min: $min, max: $max)
        }
    }
}

extension ClosedRange where Bound : Comparable {
    func coerce(_ value: Bound) -> Bound {
        switch value {
        case let x where x > upperBound:
            return upperBound
        case let x where x < lowerBound:
            return lowerBound
        default:
            return value
        }
    }
}
