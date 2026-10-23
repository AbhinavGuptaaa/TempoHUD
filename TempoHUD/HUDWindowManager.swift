//
//  HUDWindowManager.swift
//  TempoHUD
//
//  Created by user@77 on 23/10/26.
//



import SwiftUI
import AppKit
import Combine

@MainActor
final class HUDWindowManager: ObservableObject {
    private var hudWindow: NSWindow?

    func showHUD(timerModel: TimerModel) {
        if let window = hudWindow {
            window.orderFrontRegardless()
            return
        }

        let hudView = HUDView()
            .environmentObject(timerModel)
            .environmentObject(self)

        let hostingView = NSHostingView(rootView: hudView)

        let panel = NSPanel(
            contentRect: NSRect(
                x: 0, y: 0,
                width: 320, height: 170
            ),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        panel.contentView = hostingView
        panel.isFloatingPanel = true
        panel.level = .floating
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = true
        panel.hidesOnDeactivate = false
        panel.isMovableByWindowBackground = true
        panel.collectionBehavior = [
            .canJoinAllSpaces,
            .fullScreenAuxiliary
        ]

        panel.center()
        panel.orderFrontRegardless()

        hudWindow = panel
    }

    func closeHUD() {
        hudWindow?.close()
        hudWindow = nil
    }
}
