//
//  TempoHUDApp.swift
//  TempoHUD
//
//  Created by user@77 on 23/10/26.
//


import SwiftUI

@main
struct TempoHUDApp: App {
    @StateObject private var timerModel = TimerModel()
    @StateObject private var windowManager = HUDWindowManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerModel)
                .environmentObject(windowManager)
                .frame(minWidth: 380, minHeight: 360)
        }
        .windowResizability(.contentSize)
    }
}
