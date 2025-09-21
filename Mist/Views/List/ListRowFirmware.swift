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
    @Binding var copiedToClipboard: Bool
    @Binding var tasksInProgress: Bool
    @ObservedObject var taskManager: TaskManager
    @State private var alertType: FirmwareAlertType = .compatibility
    @State private var showAlert: Bool = false
    @State private var showSavePanel: Bool = false
    @State private var downloading: Bool = false
    @State private var error: Error?
    private let length: CGFloat = 48
    private let spacing: CGFloat = 5
    private let padding: CGFloat = 3
    private var compatibilityMessage: String {
        guard let architecture: Architecture = Hardware.architecture else {
            return "Invalid architecture!"
        }

        return "This macOS Firmware download cannot be used to restore macOS on this \(architecture.description) Mac.\n\nAre you sure you want to continue?"
    }

    private var errorMessage: String {
        if let error: BlessError = error as? BlessError {
            return error.description
        }

        return error?.localizedDescription ?? ""
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
            HStack(spacing: 1) {
                Button {
                    firmware.compatible ? validate() : showCompatibilityWarning()
                } label: {
                    Image(systemName: "arrow.down.circle")
                        .padding(.vertical, 1.5)
                }
                .help("Download macOS Firmware")
                .buttonStyle(.mistAction)
                Button {
                    copyToClipboard()
                } label: {
                    Image(systemName: "list.bullet.clipboard")
                }
                .help("Copy macOS Firmware URL to Clipboard")
                .buttonStyle(.mistAction)
            }
            .clipShape(Capsule())
        }
        .alert(isPresented: $showAlert) {
            switch alertType {
            case .compatibility:
                Alert(
                    title: Text("macOS Firmware not compatible!"),
                    message: Text(compatibilityMessage),
                    primaryButton: .default(Text("Cancel")),
                    secondaryButton: .default(Text("Continue")) { Task { validate() } }
                )
            case .helperTool:
                Alert(
                    title: Text("Privileged Helper Tool not installed!"),
                    message: Text("The Mist Privileged Helper Tool is required to perform Administrator tasks when downloading macOS Firmwares."),
                    primaryButton: .default(Text("Install...")) { Task { installPrivilegedHelperTool() } },
                    secondaryButton: .default(Text("Cancel"))
                )
            case .error:
                Alert(
                    title: Text("An error has occured!"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
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

    private func copyToClipboard() {
        NSPasteboard.general.declareTypes([.string], owner: nil)
        NSPasteboard.general.setString(firmware.url, forType: .string)
        withAnimation(.easeIn) {
            copiedToClipboard = true
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
        do {
            try PrivilegedHelperManager.shared.authorizeAndBless()
        } catch {
            self.error = error
            alertType = .error
            showAlert = true
        }
    }
}

struct ListRowFirmware_Previews: PreviewProvider {
    static var previews: some View {
        ListRowFirmware(firmware: .example, savePanel: .constant(NSSavePanel()), copiedToClipboard: .constant(false), tasksInProgress: .constant(false), taskManager: .shared)
    }
}
