//
//  MistApp.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import SwiftUI

@main
struct MistApp: App {
    // swiftlint:disable:next weak_delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate: AppDelegate
    @AppStorage("appIcon")
    private var appIcon: AppIcon = .default
    @StateObject var sparkleUpdater: SparkleUpdater = .init()
    @StateObject var logManager: LogManager = .shared
    @State private var refreshing: Bool = false
    @State private var tasksInProgress: Bool = false

    var body: some Scene {
        WindowGroup {
            ContentView(refreshing: $refreshing, tasksInProgress: $tasksInProgress)
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification)) { _ in
                    hideZoomButton()
                }
                .onAppear {
                    setAppIcon()
                }
        }
        .fixedWindow()
        .commands {
            AppCommands(sparkleUpdater: sparkleUpdater, refreshing: $refreshing, tasksInProgress: $tasksInProgress)
        }
        Settings {
            SettingsView(sparkleUpdater: sparkleUpdater)
        }
        WindowGroup("Mist Log") {
            LogView(logEntries: logManager.logEntries)
                .handlesExternalEvents(preferring: ["log"], allowing: ["*"])
        }
        .handlesExternalEvents(matching: ["log"])
    }

    private func hideZoomButton() {
        for window in NSApplication.shared.windows {
            guard let button: NSButton = window.standardWindowButton(NSWindow.ButtonType.zoomButton) else {
                continue
            }

            button.isEnabled = false
        }
    }

    private func setAppIcon() {
        NSApplication.shared.applicationIconImage = NSImage(named: appIcon.name)
    }
}
