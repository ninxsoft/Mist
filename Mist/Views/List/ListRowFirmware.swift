//
//  ListRowFirmware.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import Blessed
import SwiftUI

struct ListRowFirmware: View {
    @AppStorage("firmwareFilename")
    private var firmwareFilename: String = .firmwareFilenameTemplate
    @AppStorage("retries")
    private var retries: Int = 10
    @AppStorage("retryDelay")
    private var retryDelay: Int = 30
    var firmware: Firmware
    @Binding var savePanel: NSSavePanel
    @Binding var tasksInProgress: Bool
    @ObservedObject var taskManager: TaskManager
    @State private var alertType: FirmwareAlertType = .compatibility
    @State private var showAlert: Bool = false
    @State private var showSavePanel: Bool = false
    @State private var downloading: Bool = false
    private let length: CGFloat = 48
    private let spacing: CGFloat = 5
    private let padding: CGFloat = 3
    private var compatibilityMessage: String {

        guard let architecture: Architecture = Hardware.architecture else {
            return "Invalid architecture!"
        }

        return "This macOS Firmware download cannot be used to restore macOS on this \(architecture.description) Mac.\n\nAre you sure you want to continue?"
    }

    var body: some View {
        HStack {
            ListRowDetail(
                imageName: firmware.imageName,
                beta: firmware.beta,
                version: firmware.version,
                build: firmware.build,
                date: firmware.formattedDate,
                size: firmware.size.bytesString(),
                tooltip: firmware.tooltip
            )
            Button {
                firmware.compatible ? validate() : showCompatibilityWarning()
            } label: {
                Image(systemName: "arrow.down.circle")
                    .font(.body.bold())
            }
            .help("Download macOS Firmware")
            .buttonStyle(.mistAction)
            .clipShape(Capsule())
        }
        .alert(isPresented: $showAlert) {
            switch alertType {
            case .compatibility:
                return Alert(
                    title: Text("macOS Firmware not compatible!"),
                    message: Text(compatibilityMessage),
                    primaryButton: .default(Text("Cancel")),
                    secondaryButton: .default(Text("Continue")) { Task { validate() } }
                )
            case .helperTool:
                return Alert(
                    title: Text("Privileged Helper Tool not installed!"),
                    message: Text("The Mist Privileged Helper Tool is required to perform Administrator tasks when downloading macOS Firmwares"),
                    primaryButton: .default(Text("Install...")) { installPrivilegedHelperTool() },
                    secondaryButton: .default(Text("Cancel"))
                )
            }
        }
        .onChange(of: showSavePanel) { boolean in

            if boolean {
                save()
            }
        }
        .sheet(isPresented: $downloading) {
            ActivityView(
                downloadType: .firmware,
                imageName: firmware.imageName,
                name: firmware.name,
                version: firmware.version,
                build: firmware.build,
                beta: firmware.beta,
                destinationURL: savePanel.url,
                taskManager: taskManager
            )
        }
    }

    private func save() {
        showSavePanel = false
        savePanel.title = "Download Firmware"
        savePanel.nameFieldStringValue = firmwareFilename.stringWithSubstitutions(name: firmware.name, version: firmware.version, build: firmware.build)
        savePanel.canCreateDirectories = true
        savePanel.canSelectHiddenExtension = true
        savePanel.isExtensionHidden = false

        Task {
            let response: NSApplication.ModalResponse = savePanel.runModal()

            guard response == .OK else {
                return
            }

            taskManager.taskGroups = try TaskManager.taskGroups(for: firmware, destination: savePanel.url, retries: retries, delay: retryDelay)
            downloading = true
            tasksInProgress = true
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

        showSavePanel = true
    }

    private func installPrivilegedHelperTool() {
        try? PrivilegedHelperManager.shared.authorizeAndBless()
    }
}

struct ListRowFirmware_Previews: PreviewProvider {

    static var previews: some View {
        ListRowFirmware(firmware: .example, savePanel: .constant(NSSavePanel()), tasksInProgress: .constant(false), taskManager: .shared)
    }
}
