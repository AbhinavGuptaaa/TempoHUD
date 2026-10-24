//
//  HUDWindowManager.swift
//  TempoHUD
//
//  Created by user@77 on 23/10/26.
//




import SwiftUI
import AppKit
import Combine

enum HUDSize: String, CaseIterable, Identifiable {
    case compact = "Compact"
    case normal = "Normal"
    case large = "Large"

    var id: String { rawValue }

    var dimensions: CGSize {
        switch self {
        case .compact:
            return CGSize(width: 260, height: 135)
        case .normal:
            return CGSize(width: 320, height: 170)
        case .large:
            return CGSize(width: 390, height: 205)
        }
    }

    var timerFontSize: CGFloat {
        switch self {
        case .compact: return 38
        case .normal: return 51
        case .large: return 65
        }
    }
}

enum HUDBackgroundStyle: String, CaseIterable, Identifiable {
    case darkGlass = "Dark Glass"
    case frostedGlass = "Frosted Glass"
    case lightGlass = "Light Glass"

    var id: String { rawValue }
}

@MainActor
final class HUDWindowManager: ObservableObject {
    @Published var opacity: Double = 0.90
    @Published var hudSize: HUDSize = .normal
    @Published var backgroundStyle: HUDBackgroundStyle = .darkGlass

    private var hudWindow: NSWindow?

    func showHUD(timerModel: TimerModel) {
        if let window = hudWindow {
            applyAppearance()
            window.orderFrontRegardless()
            return
        }

        let hudView = HUDView()
            .environmentObject(timerModel)
            .environmentObject(self)

        let hostingView = NSHostingView(rootView: hudView)
        let dimensions = hudSize.dimensions

        let panel = NSPanel(
            contentRect: NSRect(
                x: 0,
                y: 0,
                width: dimensions.width,
                height: dimensions.height
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

        hudWindow = panel
        applyAppearance()

        panel.center()
        panel.orderFrontRegardless()
    }

    func applyAppearance() {
        guard let window = hudWindow else { return }

        window.alphaValue = opacity
        window.setContentSize(hudSize.dimensions)
    }

    func closeHUD() {
        hudWindow?.close()
        hudWindow = nil
    }
}
