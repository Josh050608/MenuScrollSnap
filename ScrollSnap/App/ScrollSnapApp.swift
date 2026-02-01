//
//  ScrollSnapApp.swift
//  ScrollSnap
//

import SwiftUI

@main
struct ScrollSnapApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra {
            Button("Capture") {
                appDelegate.toggleCapture()
            }
            .keyboardShortcut("x", modifiers: [.command, .shift])

            Divider()

            Button("Settings...") {
                appDelegate.showSettingsWindow()
            }
            .keyboardShortcut(",", modifiers: .command)

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q", modifiers: .command)
        } label: {
            Image(systemName: "camera.viewfinder")
        }
    }
}
