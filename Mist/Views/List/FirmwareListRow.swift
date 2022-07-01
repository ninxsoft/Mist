//
//  FirmwareListRow.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import SwiftUI

struct FirmwareListRow: View {
    @AppStorage("firmwareFilename") private var firmwareFilename: String = .firmwareFilenameTemplate
    @AppStorage("retries") private var retries: Int = 10
    @AppStorage("retryDelay") private var retryDelay: Int = 30
    var firmware: Firmware
    @Binding var savePanel: NSSavePanel
    @Binding var downloadInProgress: Bool
    @ObservedObject var taskManager: TaskManager
    @State private var showSavePanel: Bool = false
    @State private var downloading: Bool = false

    var body: some View {
        ListRow(
            image: firmware.imageName,
            version: firmware.version,
            build: firmware.build,
            beta: firmware.beta,
            date: firmware.formattedDate,
            size: firmware.size.bytesString(),
            alertMessage: "The Mist Privileged Helper Tool is required to perform Administrator tasks when downloading macOS Firmwares.",
            showPanel: $showSavePanel,
            taskManager: taskManager
        )
        .onChange(of: showSavePanel) { boolean in

            if boolean {
                save()
            }
        }
        .sheet(isPresented: $downloading) {
            DownloadView(
                downloadType: .firmware,
                imageName: firmware.imageName,
                name: firmware.name,
                version: firmware.version,
                build: firmware.build,
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
            downloadInProgress = true
        }
    }
}

struct FirmwareListRow_Previews: PreviewProvider {

    static var previews: some View {
        FirmwareListRow(firmware: .example, savePanel: .constant(NSSavePanel()), downloadInProgress: .constant(false), taskManager: .shared)
    }
}
