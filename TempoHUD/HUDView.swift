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

    private var foregroundColor: Color {
        windowManager.backgroundStyle == .lightGlass
            ? .black.opacity(0.85)
            : .white
    }

    private var secondaryColor: Color {
        foregroundColor.opacity(0.7)
    }

    private var backgroundColor: Color {
        switch windowManager.backgroundStyle {
        case .darkGlass:
            return .black.opacity(0.48)
        case .frostedGlass:
            return .clear
        case .lightGlass:
            return .white.opacity(0.55)
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Circle()
                    .fill(timerModel.hasFinished ? .orange : .green)
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
                .foregroundStyle(secondaryColor)

                Spacer()

                Button {
                    windowManager.closeHUD()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(secondaryColor)
                        .frame(width: 24, height: 24)
                        .background(foregroundColor.opacity(0.10))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }

            Text(timerModel.formattedTime)
                .font(
                    .system(
                        size: windowManager.hudSize.timerFontSize,
                        weight: .light,
                        design: .rounded
                    )
                )
                .monospacedDigit()
                .foregroundStyle(foregroundColor)
                .minimumScaleFactor(0.65)
                .lineLimit(1)

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
                    .padding(.vertical, 8)
                    .background(foregroundColor.opacity(0.12))
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
                        .background(foregroundColor.opacity(0.10))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            }
            .foregroundStyle(foregroundColor)
        }
        .padding(16)
        .frame(
            width: windowManager.hudSize.dimensions.width,
            height: windowManager.hudSize.dimensions.height
        )
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .fill(.ultraThinMaterial)

                RoundedRectangle(cornerRadius: 22)
                    .fill(backgroundColor)

                RoundedRectangle(cornerRadius: 22)
                    .strokeBorder(
                        foregroundColor.opacity(0.18),
                        lineWidth: 1
                    )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .preferredColorScheme(
            windowManager.backgroundStyle == .lightGlass ? .light : .dark
        )
    }
}
