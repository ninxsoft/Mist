//
//  SettingsInstallersCacheView.swift
//  Mist
//
//  Created by Nindi Gill on 17/6/2022.
//

import SwiftUI

struct SettingsInstallersCacheView: View {
    @Binding var cacheDownloads: Bool
    @Binding var cacheDirectory: String
    @State private var cacheSize: UInt64 = 0
    @State private var openPanel: NSOpenPanel = NSOpenPanel()
    @State private var installers: [Installer] = []
    @State private var selectedInstallerId: String?
    @State private var showAlert: Bool = false
    @State private var alertType: SettingsInstallerCacheAlertType = .confirmation
    private let padding: CGFloat = 5
    private var removalMessage: String {
        guard let installer: Installer = installers.first(where: { $0.id == selectedInstallerId }) else {
            return ""
        }

        return "Removing '\(installer.version.isEmpty ? installer.id : "\(installer.name) \(installer.version) (\(installer.build))")' will free up \(installer.size.bytesString())."
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading) {
                    Toggle(isOn: $cacheDownloads) { Text("Cache downloads") }
                    FooterText("Speed up future operations by caching a local copy of macOS Installer files.")
                }
                Spacer()
                Button("Select...") { selectCacheDirectory() }
                    .disabled(!cacheDownloads)
            }
            PathControl(path: $cacheDirectory)
                .disabled(true)
                .opacity(cacheDownloads ? 1 : 0.5)
            SettingsInstallersCacheTableView(installers: installers, selectedInstallerId: $selectedInstallerId, cacheDownloads: cacheDownloads)
                .padding(.bottom, padding)
            HStack(alignment: .firstTextBaseline) {
                FooterText("Cache directory currently contains \(cacheSize.bytesString()) of data.")
                Spacer()
                Button("Show in Finder") {
                    showInFinder()
                }
                .disabled(!cacheDownloads || selectedInstallerId == nil)
                Button("Remove...") {
                    alertType = .confirmation
                    showAlert = true
                }
                .disabled(!cacheDownloads || selectedInstallerId == nil)
            }
        }
        .onAppear {
            retrieveCache()
        }
        .onChange(of: cacheDirectory) { _ in
            retrieveCache()
        }
        .alert(isPresented: $showAlert) {
            switch alertType {
            case .confirmation:
                return Alert(
                    title: Text("Remove Cached Installer?"),
                    message: Text(removalMessage),
                    primaryButton: .cancel(),
                    secondaryButton: .destructive(Text("Remove")) {
                        Task {
                            await emptyCache(for: selectedInstallerId)
                            retrieveCache()
                        }
                    }
                )
            case .error:
                return Alert(
                    title: Text("An error has occured!"),
                    message: Text("There was an error removing the cached Installer directory. Show in Finder to remove manually."),
                    primaryButton: .default(Text("OK")) { },
                    secondaryButton: .default(Text("Show in Finder")) { showInFinder() }
                )
            }
        }
    }

    private func selectCacheDirectory() {
        openPanel.prompt = "Select"
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.resolvesAliases = true
        openPanel.allowsMultipleSelection = false
        openPanel.isAccessoryViewDisclosed = true

        let response: NSApplication.ModalResponse = openPanel.runModal()

        guard response == .OK,
            let url: URL = openPanel.url else {
            return
        }

        cacheDirectory = url.path
    }

    private func retrieveCache() {

        let url: URL = URL(fileURLWithPath: cacheDirectory)
        var isDirectory: ObjCBool = false

        do {
            if !FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            }

            cacheSize = try FileManager.default.sizeOfDirectory(at: url)
            let ids: [String] = try FileManager.default.contentsOfDirectory(atPath: url.path)
            var installers: [Installer] = []

            for id in ids {
                let url: URL = url.appendingPathComponent(id)

                guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory),
                    isDirectory.boolValue,
                    let installer: Installer = installer(for: url) else {
                    continue
                }

                installers.append(installer)
            }

            self.installers = installers.sorted {
                $0.version == $1.version ?
                ($0.build.count == $1.build.count ? $0.build > $1.build : $0.build.count > $1.build.count) :
                $0.version.compare($1.version, options: .numeric) == .orderedDescending
            }
            selectedInstallerId = nil
        } catch {
            print(error.localizedDescription)
        }
    }

    private func installer(for url: URL) -> Installer? {

        let id: String = url.lastPathComponent

        do {
            if let installer: Installer = Installer.legacyInstallers.first(where: { $0.id == id }) {
                return installer
            } else {
                let distributionURL: URL = url.appendingPathComponent("\(id).English.dist")
                let string: String = try String(contentsOf: distributionURL)

                if let version: String = versionFromDistribution(string),
                    let build: String = buildFromDistribution(string) {
                    let size: UInt64 = try FileManager.default.sizeOfDirectory(at: url)
                    return Installer(
                        id: id,
                        version: version,
                        build: build,
                        date: "",
                        distributionURL: "",
                        distributionSize: 0,
                        packages: [Package(url: "", size: Int(size), integrityDataURL: nil, integrityDataSize: nil)],
                        boardIDs: [],
                        deviceIDs: [],
                        unsupportedModelIdentifiers: []
                    )
                }
            }
        } catch {
            // do nothing
        }

        do {
            let size: UInt64 = try FileManager.default.sizeOfDirectory(at: url)
            return Installer(
                id: id,
                version: "",
                build: "",
                date: "",
                distributionURL: "",
                distributionSize: 0,
                packages: [Package(url: "", size: Int(size), integrityDataURL: nil, integrityDataSize: nil)],
                boardIDs: [],
                deviceIDs: [],
                unsupportedModelIdentifiers: []
            )
        } catch {
            return nil
        }
    }

    private func versionFromDistribution(_ string: String) -> String? {

        guard string.contains("<key>VERSION</key>") else {
            return nil
        }

        return string.replacingOccurrences(of: "^[\\s\\S]*<key>VERSION<\\/key>\\s*<string>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "<\\/string>[\\s\\S]*$", with: "", options: .regularExpression)
    }

    private func buildFromDistribution(_ string: String) -> String? {

        guard string.contains("<key>BUILD</key>") else {
            return nil
        }

        return string.replacingOccurrences(of: "^[\\s\\S]*<key>BUILD<\\/key>\\s*<string>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "<\\/string>[\\s\\S]*$", with: "", options: .regularExpression)
    }

    private func showInFinder() {

        guard let id: String = selectedInstallerId else {
            return
        }

        let url: URL = URL(fileURLWithPath: "\(cacheDirectory)/\(id)")
        NSWorkspace.shared.open(url)
    }

    private func emptyCache(for id: String?) async {

        guard let id: String = id else {
            return
        }

        let url: URL = URL(fileURLWithPath: "\(cacheDirectory)/\(id)")

        do {
            try await DirectoryRemover.remove(url)
        } catch {
            alertType = .error
            showAlert = true
        }
    }
}

struct SettingsInstallersCacheView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsInstallersCacheView(cacheDownloads: .constant(true), cacheDirectory: .constant(.cacheDirectory))
    }
}
