//
//  AppCommands.swift
//  Mist
//
//  Created by Nindi Gill on 15/6/2022.
//

import Blessed
import SwiftUI

struct AppCommands: Commands {
    @Environment(\.openURL)
    var openURL: OpenURLAction
    @ObservedObject var sparkleUpdater: SparkleUpdater
    @Binding var refreshing: Bool
    @Binding var tasksInProgress: Bool

    @CommandsBuilder var body: some Commands {
        CommandGroup(after: .appInfo) {
            Button("Check for Updates...") {
                sparkleUpdater.checkForUpdates()
            }
            .disabled(!sparkleUpdater.canCheckForUpdates)
        }
        CommandGroup(replacing: .newItem) {
            Button("Refresh") {
                refresh()
            }
            .keyboardShortcut("r")
            .disabled(refreshing || tasksInProgress)
        }
        CommandGroup(replacing: .systemServices) {
            Button("Install Privileged Helper Tool...") {
                install()
            }
            .disabled(tasksInProgress)
        }
        CommandGroup(replacing: .help) {
            Button("Mist Help") {
                help()
            }
        }
    }

    private func refresh() {
        refreshing = true
    }

    private func install() {
        try? PrivilegedHelperManager.shared.authorizeAndBless()
    }

    private func help() {

        guard let url: URL = URL(string: .repositoryURL) else {
            return
        }

        openURL(url)
    }
}
