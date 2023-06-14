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
    @StateObject var sparkleUpdater: SparkleUpdater = SparkleUpdater()
    @State private var refreshing: Bool = false
    @State private var tasksInProgress: Bool = false

    var body: some Scene {
        WindowGroup {
            ContentView(refreshing: $refreshing, tasksInProgress: $tasksInProgress)
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification)) { _ in
                    hideZoomButton()
                }
        }
        .fixedWindow()
        .commands {
            AppCommands(sparkleUpdater: sparkleUpdater, refreshing: $refreshing, tasksInProgress: $tasksInProgress)
        }
        Settings {
            SettingsView(sparkleUpdater: sparkleUpdater)
        }
    }

    func hideZoomButton() {

        for window in NSApplication.shared.windows {

            guard let button: NSButton = window.standardWindowButton(NSWindow.ButtonType.zoomButton) else {
                continue
            }

            button.isEnabled = false
        }
    }
}
