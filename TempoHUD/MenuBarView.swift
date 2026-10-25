//
//  MenuBarView.swift
//  TempoHUD
//
//  Created by user@77 on 24/10/26.
//

import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject private var timerModel: TimerModel
    @EnvironmentObject private var windowManager: HUDWindowManager
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "timer")
                    .font(.system(size: 26))

                VStack(alignment: .leading, spacing: 3) {
                    Text("TempoHUD")
                        .font(.headline)

                    Text(timerModel.formattedTime)
                        .font(.system(.title2, design: .monospaced))
                        .monospacedDigit()
                }
            }

            Divider()

            Text("Start a Timer")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                presetButton("5 min", seconds: 5 * 60)
                presetButton("10 min", seconds: 10 * 60)
                presetButton("25 min", seconds: 25 * 60)
            }
            .buttonStyle(.bordered)

            Divider()

            if timerModel.isRunning {
                Button {
                    timerModel.pause()
                } label: {
                    Label("Pause", systemImage: "pause.fill")
                }
            } else if timerModel.remainingSeconds > 0 {
                Button {
                    timerModel.resume()
                } label: {
                    Label("Resume", systemImage: "play.fill")
                }
            }

            Button {
                timerModel.reset()
            } label: {
                Label("Reset Timer", systemImage: "arrow.counterclockwise")
            }
            .disabled(
                timerModel.remainingSeconds == 0 &&
                !timerModel.isRunning
            )

            Divider()

            Button {
                windowManager.showHUD(timerModel: timerModel)
            } label: {
                Label("Show Floating HUD", systemImage: "macwindow")
            }

            Button {
                windowManager.closeHUD()
            } label: {
                Label("Hide Floating HUD", systemImage: "xmark")
            }

            Button {
                openWindow(id: "setup")
            } label: {
                Label("Custom Timer…", systemImage: "slider.horizontal.3")
            }
        }
        .padding(16)
        .frame(width: 280)
    }

    private func presetButton(
        _ title: String,
        seconds: Int
    ) -> some View {
        Button(title) {
            timerModel.start(seconds: seconds)
            windowManager.showHUD(timerModel: timerModel)
        }
    }
}
