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
        VStack(spacing: 20) {
            Image(systemName: "timer")
                .font(.system(size: 34, weight: .light))
                .foregroundStyle(.blue)

            VStack(spacing: 5) {
                Text("Tempo HUD")
                    .font(.system(size: 26, weight: .semibold))

                Text("Set your timer and personalize the overlay.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 8) {
                timePicker("Hours", value: $hours)
                timePicker("Minutes", value: $minutes)
                timePicker("Seconds", value: $seconds)
            }

            Divider()

            VStack(alignment: .leading, spacing: 15) {
                Label("HUD Appearance", systemImage: "slider.horizontal.3")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Opacity")
                        Spacer()
                        Text("\(Int(windowManager.opacity * 100))%")
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }

                    Slider(
                        value: $windowManager.opacity,
                        in: 0.25...1.0,
                        step: 0.05
                    )

                    HStack {
                        Text("More transparent")
                        Spacer()
                        Text("More solid")
                    }
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                }

                HStack {
                    Text("HUD Size")
                    Spacer()

                    Picker("HUD Size", selection: $windowManager.hudSize) {
                        ForEach(HUDSize.allCases) { size in
                            Text(size.rawValue).tag(size)
                        }
                    }
                    .labelsHidden()
                    .frame(width: 140)
                }

                HStack {
                    Text("Background")
                    Spacer()

                    Picker(
                        "Background",
                        selection: $windowManager.backgroundStyle
                    ) {
                        ForEach(HUDBackgroundStyle.allCases) { style in
                            Text(style.rawValue).tag(style)
                        }
                    }
                    .labelsHidden()
                    .frame(width: 160)
                }
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
        }
        .padding(24)
        .frame(width: 420)
        .onChange(of: windowManager.opacity) { _ in
            windowManager.applyAppearance()
        }
        .onChange(of: windowManager.hudSize) { _ in
            windowManager.applyAppearance()
        }
    }

    private func timePicker(
        _ title: String,
        value: Binding<Int>
    ) -> some View {
        VStack(spacing: 6) {
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
            .frame(width: 105)
        }
        .frame(maxWidth: .infinity)
    }
}
