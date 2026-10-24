//
//  TimerModel.swift
//  TempoHUD
//
//  Created by user@77 on 23/10/26.
//


import SwiftUI
import AppKit
import Combine

@MainActor
final class TimerModel: ObservableObject {
    @Published var remainingSeconds: Int = 0
    @Published var isRunning = false
    @Published var hasFinished = false

    private var deadline: Date?
    private var ticker: Timer?

    var formattedTime: String {
        let total = max(0, remainingSeconds)
        let hours = total / 3600
        let minutes = (total % 3600) / 60
        let seconds = total % 60

        if hours > 0 {
            return String(
                format: "%02d:%02d:%02d",
                hours, minutes, seconds
            )
        }

        return String(
            format: "%02d:%02d",
            minutes, seconds
        )
    }

    func start(seconds: Int) {
        guard seconds > 0 else { return }

        stopTicker()

        remainingSeconds = seconds
        hasFinished = false
        deadline = Date().addingTimeInterval(
            TimeInterval(seconds)
        )

        isRunning = true
        startTicker()
    }

    func resume() {
        guard !isRunning, remainingSeconds > 0 else {
            return
        }

        hasFinished = false
        deadline = Date().addingTimeInterval(
            TimeInterval(remainingSeconds)
        )

        isRunning = true
        startTicker()
    }

    func pause() {
        guard isRunning else { return }

        updateCountdown()
        stopTicker()
        deadline = nil
        isRunning = false
    }

    func reset() {
        stopTicker()
        deadline = nil
        isRunning = false
        hasFinished = false
        remainingSeconds = 0
    }

    private func startTicker() {
        stopTicker()

        ticker = Timer.scheduledTimer(
            withTimeInterval: 0.2,
            repeats: true
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.updateCountdown()
            }
        }

        updateCountdown()
    }

    private func updateCountdown() {
        guard isRunning, let deadline = deadline else {
            return
        }

        let difference = deadline.timeIntervalSinceNow

        if difference <= 0 {
            remainingSeconds = 0
            isRunning = false
            hasFinished = true
            stopTicker()
            self.deadline = nil

            NSSound(named: "Glass")?.play()
        } else {
            remainingSeconds = Int(ceil(difference))
        }
    }

    private func stopTicker() {
        ticker?.invalidate()
        ticker = nil
    }
}
