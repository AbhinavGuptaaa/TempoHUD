//
//  ContentView.swift
//  TempoHUD
//
//  Created by user@77 on 23/10/26.
//


import SwiftUI

struct ContentView: View {
    @EnvironmentObject var timerModel: TimerModel
    @EnvironmentObject var windowManager: HUDWindowManager

    @State private var hours = 0
    @State private var minutes = 25
    @State private var seconds = 0

    private var totalSeconds: Int {
        hours * 3600 + minutes * 60 + seconds
    }

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "timer")
                .font(.system(size: 38, weight: .light))
                .foregroundStyle(.blue)

            VStack(spacing: 6) {
                Text("Tempo HUD")
                    .font(.system(size: 27, weight: .semibold))

                Text("Set a timer. Stay in your flow.")
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {
                timePicker("Hours", value: $hours)
                timePicker("Minutes", value: $minutes)
                timePicker("Seconds", value: $seconds)
            }

            Button {
                guard totalSeconds > 0 else { return }

                timerModel.start(seconds: totalSeconds)
                windowManager.showHUD(timerModel: timerModel)
            } label: {
                Label("Start Timer", systemImage: "play.fill")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 5)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(totalSeconds == 0)

            Text("Your timer will float above other windows.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(28)
        .frame(width: 400, height: 370)
    }

    private func timePicker(
        _ title: String,
        value: Binding<Int>
    ) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Picker(title, selection: value) {
                ForEach(0..<60, id: \.self) { number in
                    Text(String(format: "%02d", number))
                        .tag(number)
                }
            }
            .labelsHidden()
            .frame(width: 100)
        }
        .frame(maxWidth: .infinity)
    }
}
