//
//  ListRow.swift
//  Mist
//
//  Created by Nindi Gill on 28/6/2022.
//

import Blessed
import SwiftUI

struct ListRow: View {
    var type: DownloadType
    var image: String
    var version: String
    var build: String
    var beta: Bool
    var date: String
    var size: String
    var compatible: Bool
    @Binding var showPanel: Bool
    @ObservedObject var taskManager: TaskManager
    @State private var alertType: DownloadAlertType = .compatibility
    @State private var showAlert: Bool = false
    private let length: CGFloat = 48
    private let spacing: CGFloat = 5
    private var compatibilityTitle: String {
        "macOS \(type.description) not compatible!"
    }
    private var compatibilityMessage: String {

        guard let architecture: String = Hardware.architecture else {
            return "Invalid architecture!"
        }

        let deviceType: String = architecture.contains("arm64") ? "Apple Silicon" : "Intel-based"
        let operation: String = type == .firmware ? "restore" : "re-install"
        let string: String = "This macOS \(type.description) download cannot be used to \(operation) macOS on this \(deviceType) Mac.\n\nAre you sure you want to continue?"
        return string
    }
    private var privilegedHelperToolTitle: String {
        "Privileged Helper Tool not installed!"
    }
    private var privilegedHelperToolMessage: String {
        "The Mist Privileged Helper Tool is required to perform Administrator tasks when \(type == .firmware ? "downloading macOS Firmwares" : "creating macOS Installers")."
    }

    var body: some View {
        HStack {
            ScaledImage(name: image, length: length)
            HStack(spacing: spacing) {
                Text(version)
                    .font(.title2)
                Text("(\(build))")
                    .foregroundColor(.secondary)
            }
            .textSelection(.enabled)
            if beta {
                TextTag(title: "Beta")
            }
            Spacer()
            Text(date)
                .foregroundColor(.secondary)
                .textSelection(.enabled)
            Text(size)
                .textSelection(.enabled)
            Button {
                compatible ? validate() : showCompatibilityWarning()
            } label: {
                Image(systemName: "arrow.down.circle")
                    .foregroundColor(.accentColor)
            }
        }
        .alert(isPresented: $showAlert) {
            switch alertType {
            case .compatibility:
                return Alert(
                    title: Text(compatibilityTitle),
                    message: Text(compatibilityMessage),
                    primaryButton: .default(Text("Cancel")),
                    secondaryButton: .default(Text("Continue")) { validate() }
                )
            case .helperTool:
                return Alert(
                    title: Text(privilegedHelperToolTitle),
                    message: Text(privilegedHelperToolMessage),
                    primaryButton: .default(Text("Install...")) { install() },
                    secondaryButton: .default(Text("Cancel"))
                )
            }
        }
    }

    private func showCompatibilityWarning() {
        alertType = .compatibility
        showAlert = true
    }

    private func validate() {

        guard PrivilegedHelperTool.isInstalled() else {
            alertType = .helperTool
            showAlert = true
            return
        }

        showPanel = true
    }

    private func install() {
        try? PrivilegedHelperManager.shared.authorizeAndBless()
    }
}

struct ListRow_Previews: PreviewProvider {
    static let firmware: Firmware = .example
    static let installer: Installer = .example

    static var previews: some View {
        ListRow(
            type: .firmware,
            image: firmware.imageName,
            version: firmware.version,
            build: firmware.build,
            beta: firmware.beta,
            date: firmware.formattedDate,
            size: firmware.size.bytesString(),
            compatible: firmware.compatible,
            showPanel: .constant(false),
            taskManager: .shared
        )
        ListRow(
            type: .installer,
            image: installer.imageName,
            version: installer.version,
            build: installer.build,
            beta: installer.beta,
            date: installer.date,
            size: installer.size.bytesString(),
            compatible: firmware.compatible,
            showPanel: .constant(false),
            taskManager: .shared
        )
    }
}
