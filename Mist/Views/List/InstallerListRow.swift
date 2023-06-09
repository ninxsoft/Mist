//
//  InstallerListRow.swift
//  Mist
//
//  Created by Nindi Gill on 17/6/2022.
//

import SwiftUI

struct InstallerListRow: View {
    @AppStorage("cacheDownloads")
    private var cacheDownloads: Bool = false
    @AppStorage("cacheDirectory")
    private var cacheDirectory: String = .cacheDirectory
    @AppStorage("applicationFilename")
    private var applicationFilename: String = .applicationFilenameTemplate
    @AppStorage("diskImageFilename")
    private var diskImageFilename: String = .diskImageFilenameTemplate
    @AppStorage("diskImageSign")
    private var diskImageSign: Bool = false
    @AppStorage("diskImageSigningIdentity")
    private var diskImageSigningIdentity: String = ""
    @AppStorage("isoFilename")
    private var isoFilename: String = .isoFilenameTemplate
    @AppStorage("packageFilename")
    private var packageFilename: String = .packageFilenameTemplate
    @AppStorage("packageIdentifier")
    private var packageIdentifier: String = .packageIdentifierTemplate
    @AppStorage("packageSign")
    private var packageSign: Bool = false
    @AppStorage("packageSigningIdentity")
    private var packageSigningIdentity: String = ""
    @AppStorage("retries")
    private var retries: Int = 10
    @AppStorage("retryDelay")
    private var retryDelay: Int = 30
    var installer: Installer
    @Binding var openPanel: NSOpenPanel
    @Binding var downloadInProgress: Bool
    @ObservedObject var taskManager: TaskManager
    @State private var showOpenPanel: Bool = false
    @State private var downloading: Bool = false
    @State private var exports: [InstallerExportType] = []

    var body: some View {
        ListRow(
            type: .installer,
            image: installer.imageName,
            version: installer.version,
            build: installer.build,
            beta: installer.beta,
            date: installer.date,
            size: installer.size.bytesString(),
            compatible: installer.compatible,
            showPanel: $showOpenPanel,
            taskManager: taskManager
        )
        .onChange(of: showOpenPanel) { boolean in

            if boolean {
                open()
            }
        }
        .sheet(isPresented: $downloading) {
            DownloadView(
                downloadType: .installer,
                imageName: installer.imageName,
                name: installer.name.replacingOccurrences(of: " beta", with: ""),
                version: installer.version,
                build: installer.build,
                beta: installer.beta,
                destinationURL: openPanel.url,
                taskManager: taskManager
            )
        }
    }

    private func open() {
        showOpenPanel = false
        openPanel.title = "Download Installer"
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = false
        openPanel.prompt = "Save"
        openPanel.accessoryView = NSHostingView(rootView: InstallerExportView(installer: installer, exports: $exports))
        openPanel.isAccessoryViewDisclosed = true

        Task {
            let response: NSApplication.ModalResponse = openPanel.runModal()

            guard response == .OK else {
                return
            }

            taskManager.taskGroups = try TaskManager.taskGroups(
                for: installer,
                destination: openPanel.url,
                exports: exports,
                cacheDownloads: cacheDownloads,
                cacheDirectory: cacheDirectory,
                retries: retries,
                delay: retryDelay,
                applicationFilename: applicationFilename,
                diskImageFilename: diskImageFilename,
                diskImageSign: diskImageSign,
                diskImageSigningIdentity: diskImageSigningIdentity,
                isoFilename: isoFilename,
                packageFilename: packageFilename,
                packageIdentifier: packageIdentifier,
                packageSign: packageSign,
                packageSigningIdentity: packageSigningIdentity
            )

            downloading = true
            downloadInProgress = true
        }
    }
}

struct InstallerListRow_Previews: PreviewProvider {
    static var previews: some View {
        InstallerListRow(installer: .example, openPanel: .constant(NSOpenPanel()), downloadInProgress: .constant(false), taskManager: .shared)
    }
}
