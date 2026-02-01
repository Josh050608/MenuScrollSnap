//
//  AppDelegate.swift
//  ScrollSnap
//

import SwiftUI
import Carbon

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    let overlayManager = OverlayManager()
    private var settingsWindowController: SettingsWindowController?
    private var permissionWindow: NSWindow?
    private var globalHotKeyMonitor: Any?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMainMenu()

        cleanupOldTemporaryFiles()

        Task {
            let hasPermission = await checkScreenRecordingPermission()
            await MainActor.run {
                if !hasPermission {
                    self.showPermissionRequestWindow()
                }
            }
        }

        // Setup global hotkey (Cmd+Shift+X)
        setupGlobalHotKey()

        // Setup escape key handler
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self = self else { return event }

            if event.keyCode == 53 { // Escape
                if self.overlayManager.areOverlaysVisible() {
                    self.overlayManager.hideOverlays()
                    return nil
                }
            }
            return event
        }
    }

    private func setupGlobalHotKey() {
        globalHotKeyMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            // Cmd+Shift+X
            if event.modifierFlags.contains([.command, .shift]) && event.keyCode == 7 { // X key
                Task { @MainActor in
                    self?.toggleCapture()
                }
            }
        }
    }

    /// Toggles the capture overlay on/off
    func toggleCapture() {
        Task {
            let hasPermission = await checkScreenRecordingPermission()
            await MainActor.run {
                if hasPermission {
                    if overlayManager.areOverlaysVisible() {
                        overlayManager.hideOverlays()
                    } else {
                        overlayManager.setupOverlays()
                    }
                } else {
                    self.showPermissionRequestWindow()
                }
            }
        }
    }
    
    private func setupMainMenu() {
        let mainMenu = NSMenu()
        
        let appMenuItem = NSMenuItem(title: "ScrollSnap", action: nil, keyEquivalent: "")
        let appMenu = NSMenu(title: "ScrollSnap")
        appMenu.addItem(withTitle: "About ScrollSnap", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(withTitle: "Preferences…", action: #selector(showSettingsWindow), keyEquivalent: ",")
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(withTitle: "Quit ScrollSnap", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        appMenuItem.submenu = appMenu
        mainMenu.addItem(appMenuItem)
        
        NSApplication.shared.mainMenu = mainMenu
    }
    
    @objc func showSettingsWindow() {
        if settingsWindowController == nil {
            settingsWindowController = SettingsWindowController(overlayManager: overlayManager)
        }
        settingsWindowController?.showWindow(nil)
        settingsWindowController?.window?.makeKeyAndOrderFront(nil)
    }
    
    private func showPermissionRequestWindow() {
        let permissionView = PermissionRequestView()
        let hostingController = NSHostingController(rootView: permissionView)
        
        permissionWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 450, height: 400),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        
        permissionWindow?.center()
        permissionWindow?.contentViewController = hostingController
        permissionWindow?.title = "Screen Recording Permission"
        permissionWindow?.level = .floating
        permissionWindow?.makeKeyAndOrderFront(nil)
    }
    
    // MARK: - Temporary File Cleanup
    
    /// Cleans up ScrollSnap temporary files older than the specified retention period
    private func cleanupOldTemporaryFiles() {
        let tempDirectory = FileManager.default.temporaryDirectory
        let retentionDays = 7 // Files older than this will be deleted
        
        do {
            let tempContents = try FileManager.default.contentsOfDirectory(
                at: tempDirectory,
                includingPropertiesForKeys: [.creationDateKey, .isRegularFileKey],
                options: .skipsHiddenFiles
            )
            
            let cutoffDate = Calendar.current.date(byAdding: .day, value: -retentionDays, to: Date()) ?? Date()
            
            for fileURL in tempContents {
                // Only process files that match ScrollSnap's naming pattern
                guard fileURL.lastPathComponent.hasPrefix("Screenshot ") &&
                      fileURL.pathExtension == "png" else {
                    continue
                }
                
                do {
                    let resourceValues = try fileURL.resourceValues(forKeys: [.creationDateKey, .isRegularFileKey])
                    
                    // Ensure it's a regular file
                    guard resourceValues.isRegularFile == true else { continue }
                    
                    // Check if file is older than cutoff date
                    if let creationDate = resourceValues.creationDate,
                       creationDate < cutoffDate {
                        try FileManager.default.removeItem(at: fileURL)
                    }
                } catch {
                    print("Failed to process temp file \(fileURL.lastPathComponent): \(error.localizedDescription)")
                }
            }
        } catch {
            print("Failed to clean up temporary files: \(error.localizedDescription)")
        }
    }
}
