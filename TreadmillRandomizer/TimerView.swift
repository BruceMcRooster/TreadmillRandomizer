//
//  Timer.swift
//  TreadmillRandomizer
//
//  Created by Evan on 11/27/23.
//

import SwiftUI
import Foundation
import AVFoundation

struct TimerView: View {
    
    let intervalSound: SystemSoundID = 1323
    let finishingSound: SystemSoundID = 1325
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let timerConfig: TimerInitialization

    init(_ timerConfig: TimerInitialization) {
        self.timerConfig = timerConfig
        _timeRemaining = State<Int>(initialValue: timerConfig.totalTime * 60)
        _intervalTimeRemaining = State<Int>(initialValue: timerConfig.intervalTime * 60)
    }
    
    @State private var totalTimerPercentage: Double = 100
    @State private var intervalTimerPercentage: Double = 100

    @State private var timeRemaining: Int
    @State private var intervalTimeRemaining: Int
    
    @State private var intervalSpeed: Double = 0.0
    @State private var intervalElevation: Double = 0.0
    
    @State private var timerState: TimerState = .unstarted
    
    @State var timer = Timer.publish(every: 10000, on: .current, in: .common).autoconnect()
    
    private var currentInterval: Int {
        if timerState == .unstarted || timerState == .finished {
            return 0
        }
        
        let timeIn = timerConfig.totalTime * 60 - timeRemaining
        return Int(timeIn/(timerConfig.intervalTime * 60)) + 1
    }
    
    private func newInterval() {
        AudioServicesPlaySystemSound(intervalSound)
        
        intervalSpeed = (Double.random(in: timerConfig.speedRange) * 10).rounded() / 10
        intervalElevation = confineElevation(Double.random(in: timerConfig.elevationRange))
        intervalTimeRemaining = timerConfig.intervalTime * 60
    }
    
    var body: some View {
        VStack {
            Text("\(currentInterval)/\(Int((Double(timerConfig.totalTime) / Double(timerConfig.intervalTime)).rounded(.up)))")
                .font(.largeTitle.bold())
                .padding()
            ZStack {
                Ring(lineWidth: 40, backgroundColor: Color.blue.opacity(0.2), foregroundColor: Color.blue, percentage: totalTimerPercentage)
                    .frame(width: 300, height: 300)
                
                Ring(lineWidth: 40, backgroundColor: Color.purple.opacity(0.2), foregroundColor: Color.purple, percentage: intervalTimerPercentage)
                    .frame(width: 210, height: 210)
                
                Text("\(String(Int(intervalTimeRemaining / 60))):\(padZeroOnLeft(s: String(intervalTimeRemaining % 60), length: 2))")
                    .font(.title)
            }
            if timerState == .unstarted {
                HStack {
                    Text("\(Image(systemName: "figure.run")) \(timerConfig.speedRange.lowerBound, specifier: "%.1f")-\(timerConfig.speedRange.upperBound, specifier: "%.1f")")
                        .font(.title.bold())
                        .padding(.trailing)
                    Text("\(Image(systemName: "arrow.up.forward")) \(timerConfig.elevationRange.lowerBound, specifier: "%.1f")-\(timerConfig.elevationRange.upperBound, specifier: "%.1f")")
                        .font(.title.bold())
                        .padding(.leading)
                }
                
                Button(action: {
                    self.timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
                    timerState = .running
                    newInterval()
                    UIApplication.shared.isIdleTimerDisabled = true
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                            .frame(height: 80)
                            .foregroundStyle(.green)
                        Text("Start")
                            .padding()
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)
                    }
                })
                .padding()
            } else if timerState == .finished {
                Text("Workout Finished")
                    .font(.title.bold())
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                            .frame(height: 80)
                            .foregroundStyle(.green)
                        Text("Done")
                            .padding()
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)
                    }
                })
                .padding()
                
            } else {
                HStack {
                    Text("\(Image(systemName: "figure.run")) \(intervalSpeed, specifier: "%.1f")")
                        .font(.title.bold())
                        .padding(.trailing)
                    Text("\(Image(systemName: "arrow.up.forward")) \(intervalElevation, specifier: "%.1f")")
                        .font(.title.bold())
                        .padding(.leading)
                }
                
                if timerState == .running {
                    Button(action: {
                        self.timer.upstream.connect().cancel()
                        timerState = .paused
                        UIApplication.shared.isIdleTimerDisabled = false
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                                .frame(height: 80)
                                .foregroundStyle(.orange)
                            Text("Pause")
                                .padding()
                                .font(.largeTitle.bold())
                                .foregroundStyle(.white)
                        }
                    })
                    .padding()
                } else {
                    Button(action: {
                        self.timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
                        timerState = .running
                        UIApplication.shared.isIdleTimerDisabled = true
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                                .frame(height: 80)
                                .foregroundStyle(.green)
                            Text("Resume")
                                .padding()
                                .font(.largeTitle.bold())
                                .foregroundStyle(.white)
                        }
                    })
                    .padding()
                }
            }
        }
        .onReceive(timer) { _ in
            timeRemaining -= 1
            intervalTimeRemaining -= 1
            if timeRemaining <= 0 {
                AudioServicesPlaySystemSound(finishingSound)
                self.timer.upstream.connect().cancel()
                timerState = .finished
                totalTimerPercentage = 0
                intervalTimerPercentage = 0
                timeRemaining = 0
                intervalTimeRemaining = 0
                UIApplication.shared.isIdleTimerDisabled = false
            } else if intervalTimeRemaining <= 0 {
                newInterval()
            }
            totalTimerPercentage = Double(timeRemaining) / Double(timerConfig.totalTime * 60) * 100
            intervalTimerPercentage = Double(intervalTimeRemaining) / Double(timerConfig.intervalTime * 60) * 100
            
            
        }
    }
}

#Preview {
    TimerView(TimerInitialization(totalTime: 20, intervalTime: 2))
}

fileprivate func padZeroOnLeft(s: String, length: Int) -> String {
    let padZeroSize = max(0, length - s.count)
    let newStr = String(repeating: "0", count: padZeroSize) + s
    return newStr
 }

enum TimerState {
    case unstarted, running, paused, finished
}
