//
//  ListRowInstaller.swift
//  Mist
//
//  Created by Nindi Gill on 17/6/2022.
//

import Blessed
import SwiftUI
import System

// swiftlint:disable:next type_body_length
struct ListRowInstaller: View {
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
    @Binding var tasksInProgress: Bool
    @ObservedObject var taskManager: TaskManager
    @State private var alertType: InstallerAlertType = .compatibility
    @State private var showAlert: Bool = false
    @State private var sheetType: InstallerSheetType = .download
    @State private var showSheet: Bool = false
    @State private var showOpenPanel: Bool = false
    @State private var exports: [InstallerExportType] = []
    @State private var volume: InstallerVolume?
    private let length: CGFloat = 48
    private let spacing: CGFloat = 5
    private let padding: CGFloat = 3
    private var compatibilityMessage: String {

        guard let architecture: Architecture = Hardware.architecture else {
            return "Invalid architecture!"
        }

        return "This macOS Installer download cannot be used to restore macOS on this \(architecture.description) Mac.\n\nAre you sure you want to continue?"
    }
    private var cacheDirectoryMessage: String {
        "The cache directory has incorrect ownership and/or permissions, which will cause issues caching macOS Installers.\n\nRepair the cache directory ownership and/or permissions and try again."
    }

    var body: some View {
        HStack {
            ListRowDetail(
                imageName: installer.imageName,
                beta: installer.beta,
                version: installer.version,
                build: installer.build,
                date: installer.date,
                size: installer.size.bytesString(),
                tooltip: installer.tooltip
            )
            HStack(spacing: 1) {
                Button {
                    pressButton(.download)
                } label: {
                    Image(systemName: "arrow.down.circle").font(.body.bold())
                }
                .help("Download and export macOS Installer")
                .buttonStyle(.mistAction)
                if let architecture: Architecture = Hardware.architecture,
                    (architecture == .appleSilicon && installer.bigSurOrNewer) || (architecture == .intel && installer.mavericksOrNewer) {
                    Button {
                        pressButton(.volumeSelection)
                    } label: {
                        Image(systemName: "externaldrive").font(.body.bold())
                            .padding(.vertical, 1)
                    }
                    .help("Create bootable macOS Installer")
                    .buttonStyle(.mistAction)
                }
            }
            .clipShape(Capsule())
        }
        .alert(isPresented: $showAlert) {
            switch alertType {
            case .compatibility:
                return Alert(
                    title: Text("macOS Installer not compatible!"),
                    message: Text(compatibilityMessage),
                    primaryButton: .default(Text("Cancel")),
                    secondaryButton: .default(Text("Continue")) { Task { validate() } }
                )
            case .helperTool:
                return Alert(
                    title: Text("Privileged Helper Tool not installed!"),
                    message: Text("The Mist Privileged Helper Tool is required to perform Administrator tasks when creating macOS Installers."),
                    primaryButton: .default(Text("Install...")) { installPrivilegedHelperTool() },
                    secondaryButton: .default(Text("Cancel"))
                )
            case .fullDiskAccess:
                return Alert(
                    title: Text("Full Disk Access required!"),
                    message: Text("Mist requires Full Disk Access to perform Administrator tasks when creating macOS Installers."),
                    primaryButton: .default(Text("Allow...")) { openFullDiskAccessPreferences() },
                    secondaryButton: .default(Text("Cancel"))
                )
            case .cacheDirectory:
                return Alert(
                    title: Text("Cache directory settings incorrect!"),
                    message: Text(cacheDirectoryMessage),
                    primaryButton: .default(Text("Repair...")) { Task { try await repairCacheDirectoryOwnershipAndPermissions() } },
                    secondaryButton: .default(Text("Cancel"))
                )
            }
        }
        .onChange(of: showOpenPanel) { boolean in

            if boolean {
                open()
            }
        }
        .onChange(of: volume) { volume in

            if volume != nil {
                createBootableInstaller()
            }
        }
        .onChange(of: sheetType) { _ in } // hack to make cascading sheets work
        .sheet(isPresented: $showSheet) {
            switch sheetType {
            case .download:
                ActivityView(
                    downloadType: .installer,
                    imageName: installer.imageName,
                    name: installer.name.replacingOccurrences(of: " beta", with: ""),
                    version: installer.version,
                    build: installer.build,
                    beta: installer.beta,
                    destinationURL: openPanel.url,
                    taskManager: taskManager
                )
            case .volumeSelection:
                InstallerVolumeSelectionView(volume: $volume)
            case .createBootableInstaller:
                ActivityView(
                    downloadType: .installer,
                    imageName: installer.imageName,
                    name: installer.name.replacingOccurrences(of: " beta", with: ""),
                    version: installer.version,
                    build: installer.build,
                    beta: installer.beta,
                    destinationURL: URL(fileURLWithPath: "/Volumes/Install \(installer.name)"),
                    taskManager: taskManager
                )
            }
        }
    }

    private func pressButton(_ type: InstallerSheetType) {
        sheetType = type

        if installer.compatible {
            Task { validate() }
        } else {
            showCompatibilityWarning()
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

            showSheet = true
            tasksInProgress = true
        }
    }

    private func createBootableInstaller() {

        guard let volume: InstallerVolume = volume else {
            return
        }

        Task {
            taskManager.taskGroups = try TaskManager.taskGroups(
                for: installer,
                cacheDownloads: cacheDownloads,
                cacheDirectory: cacheDirectory,
                retries: retries,
                delay: retryDelay,
                volume: volume
            )

            sheetType = .createBootableInstaller
            showSheet = true
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

        guard FileManager.default.isReadableFile(atPath: .tccDatabasePath) else {
            alertType = .fullDiskAccess
            showAlert = true
            return
        }

        if cacheDownloads {

            do {
                var isDirectory: ObjCBool = false

                if !FileManager.default.fileExists(atPath: cacheDirectory, isDirectory: &isDirectory) {
                    try FileManager.default.createDirectory(atPath: cacheDirectory, withIntermediateDirectories: true)
                }

                let attributes: [FileAttributeKey: Any] = try FileManager.default.attributesOfItem(atPath: cacheDirectory)

                guard let posixPermissions: NSNumber = attributes[.posixPermissions] as? NSNumber else {
                    alertType = .cacheDirectory
                    showAlert = true
                    return
                }

                let filePermissions: FilePermissions = FilePermissions(rawValue: CModeT(posixPermissions.int16Value))

                guard filePermissions == [.ownerReadWriteExecute, .groupReadExecute, .otherReadExecute],
                    let ownerAccountName: String = attributes[.ownerAccountName] as? String,
                    ownerAccountName == NSUserName(),
                    let groupOwnerAccountName: String = attributes[.groupOwnerAccountName] as? String,
                    groupOwnerAccountName == "wheel" else {
                    alertType = .cacheDirectory
                    showAlert = true
                    return
                }
            } catch {
                alertType = .cacheDirectory
                showAlert = true
                return
            }
        }

        switch sheetType {
        case .download:
            showOpenPanel = true
        case .volumeSelection:
            showSheet = true
        case .createBootableInstaller:
            break
        }
    }

    private func installPrivilegedHelperTool() {
        try? PrivilegedHelperManager.shared.authorizeAndBless()
    }

    private func openFullDiskAccessPreferences() {

        guard let url: URL = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles") else {
            return
        }

        NSWorkspace.shared.open(url)
    }

    private func repairCacheDirectoryOwnershipAndPermissions() async throws {
        let url: URL = URL(fileURLWithPath: cacheDirectory)
        let ownerAccountName: String = NSUserName()
        try await FileAttributesUpdater.update(url: url, ownerAccountName: ownerAccountName)
    }
}

struct ListRowInstaller_Previews: PreviewProvider {
    static var previews: some View {
        ListRowInstaller(installer: .example, openPanel: .constant(NSOpenPanel()), tasksInProgress: .constant(false), taskManager: .shared)
    }
}
