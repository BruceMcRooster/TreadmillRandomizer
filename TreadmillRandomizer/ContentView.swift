//
//  ContentView.swift
//  TreadmillRandomizer
//
//  Created by Evan on 11/26/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @AppStorage("speedMin") var speedMin = 1.0
    @AppStorage("speedMax") var speedMax = 2.0
    
    @AppStorage("elevationMin") var elevationMin = 0.0
    @AppStorage("elevationMax") var elevationMax = 3.0
    
    @AppStorage("workoutTime") var workoutTime = 10
    @AppStorage("intervalTime") var intervalTime = 2
    
    var body: some View {
        NavigationStack {
            Form {
                SpeedSelector(min: $speedMin, max: $speedMax)
                ElevationSelector(min: $elevationMin, max: $elevationMax)
                
                Section("Time") {
                    Picker("Workout Time", selection: $workoutTime) {
                        ForEach(Array(stride(from: 5, through: 120, by: 5)), id: \.self) { number in
                            Text("\(number) min")
                        }
                    }
                    .pickerStyle(.wheel)
                    Picker("Interval Time", selection: $intervalTime) {
                        Text("1 min").tag(1)
                        Text("2 min").tag(2)
                        Text("5 min").tag(5)
                        Text("10 min").tag(10)
                    }
                }
                NavigationLink("Start Workout", value: TimerInitialization(speedRange: (min(speedMin, speedMax)...max(speedMin, speedMax)), elevationRange: (confineElevation(min(elevationMin, elevationMax))...confineElevation(max(elevationMin, elevationMax))), totalTime: workoutTime, intervalTime: intervalTime))
            }
            .navigationTitle("New Workout")
            .navigationDestination(for: TimerInitialization.self) { timerinit in
                TimerView(timerinit)
            }
        }
    }
}

#Preview {
    ContentView()
}

struct TimerInitialization: Hashable {
    let speedRange: ClosedRange<Double>
    let elevationRange: ClosedRange<Double>
    
    let totalTime: Int
    let intervalTime: Int
    
    init(speedRange: ClosedRange<Double> = 1.0...2.0, elevationRange: ClosedRange<Double> = 0.0...3.0, totalTime: Int = 10, intervalTime: Int = 2) {
        self.speedRange = speedRange
        self.elevationRange = elevationRange
        self.totalTime = totalTime
        self.intervalTime = intervalTime
    }
}
