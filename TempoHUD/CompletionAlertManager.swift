//
//  CompletionAlertManager.swift
//  TempoHUD
//
//  Created by user@77 on 27/10/26.
//

import AppKit
import UserNotifications
import Combine

@MainActor
final class CompletionAlertManager: ObservableObject {
    @Published var notificationsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(
                notificationsEnabled,
                forKey: "completionNotificationsEnabled"
            )

            if notificationsEnabled {
                requestNotificationPermission()
            }
        }
    }

    @Published var selectedSound: String {
        didSet {
            UserDefaults.standard.set(
                selectedSound,
                forKey: "completionSound"
            )
        }
    }

    let soundOptions = [
        "None",
        "Glass",
        "Ping",
        "Pop",
        "Purr",
        "Submarine",
        "Funk",
        "Hero"
    ]

    init() {
        notificationsEnabled = UserDefaults.standard.bool(
            forKey: "completionNotificationsEnabled"
        )

        selectedSound = UserDefaults.standard.string(
            forKey: "completionSound"
        ) ?? "Glass"
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) { _, error in
                if let error {
                    print("Notification permission error: \(error.localizedDescription)")
                }
            }
    }

    func playCompletionSound() {
        guard selectedSound != "None" else { return }
        NSSound(named: NSSound.Name(selectedSound))?.play()
    }

    func sendCompletionNotification() {
        guard notificationsEnabled else { return }

        let content = UNMutableNotificationContent()
        content.title = "TempoHUD"
        content.body = "Your timer has finished!"
        content.sound = nil

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Notification error: \(error.localizedDescription)")
            }
        }
    }

    func previewSound() {
        playCompletionSound()
    }
}
