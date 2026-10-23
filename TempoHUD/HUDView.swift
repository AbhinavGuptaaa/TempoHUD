//
//  HUDView.swift
//  TempoHUD
//
//  Created by user@77 on 23/10/26.
//


import SwiftUI

struct HUDView: View {
    @EnvironmentObject var timerModel: TimerModel
    @EnvironmentObject var windowManager: HUDWindowManager

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Circle()
                    .fill(
                        timerModel.hasFinished
                            ? Color.orange
                            : Color.green
                    )
                    .frame(width: 7, height: 7)

                Text(
                    timerModel.hasFinished
                        ? "TIME'S UP"
                        : timerModel.isRunning
                            ? "COUNTDOWN"
                            : "PAUSED"
                )
                .font(.system(size: 10, weight: .semibold))
                .tracking(2)
                .foregroundStyle(.white.opacity(0.7))

                Spacer()

                Button {
                    windowManager.closeHUD()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white.opacity(0.7))
                        .frame(width: 24, height: 24)
                        .background(.white.opacity(0.10))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }

            Text(timerModel.formattedTime)
                .font(
                    .system(
                        size: 51,
                        weight: .light,
                        design: .rounded
                    )
                )
                .monospacedDigit()
                .foregroundStyle(.white)
                .contentTransition(.numericText())

            HStack(spacing: 12) {
                Button {
                    if timerModel.isRunning {
                        timerModel.pause()
                    } else {
                        timerModel.resume()
                    }
                } label: {
                    Label(
                        timerModel.isRunning ? "Pause" : "Resume",
                        systemImage: timerModel.isRunning
                            ? "pause.fill"
                            : "play.fill"
                    )
                    .font(.system(size: 12, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 9)
                    .background(.white.opacity(0.14))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
                .disabled(
                    timerModel.remainingSeconds == 0
                        || timerModel.hasFinished
                )

                Button {
                    timerModel.reset()
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 13, weight: .medium))
                        .frame(width: 38, height: 34)
                        .background(.white.opacity(0.10))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            }
            .foregroundStyle(.white)
        }
        .padding(18)
        .frame(width: 320, height: 170)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .fill(.ultraThinMaterial)

                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.black.opacity(0.45))

                RoundedRectangle(cornerRadius: 22)
                    .strokeBorder(
                        .white.opacity(0.18),
                        lineWidth: 1
                    )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .preferredColorScheme(.dark)
    }
}
