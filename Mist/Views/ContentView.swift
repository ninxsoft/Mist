//
//  ContentView.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("downloadType")
    private var downloadType: DownloadType = .firmware
    @AppStorage("includeBetas")
    private var includeBetas: Bool = false
    @AppStorage("showCompatible")
    private var showCompatible: Bool = false
    @Binding var refreshing: Bool
    @Binding var tasksInProgress: Bool
    @State private var firmwares: [Firmware] = []
    @State private var installers: [Installer] = []
    @State private var searchString: String = ""
    @State private var openPanel: NSOpenPanel = NSOpenPanel()
    @State private var savePanel: NSSavePanel = NSSavePanel()
    @StateObject private var taskManager: TaskManager = TaskManager.shared
    private var filteredFirmwares: [Firmware] {
        var filteredFirmwares: [Firmware] = firmwares

        if !searchString.isEmpty {
            let string: String = searchString.lowercased()
            filteredFirmwares = filteredFirmwares.filter {
                $0.name.lowercased().contains(string) ||
                $0.version.lowercased().contains(string) ||
                $0.build.lowercased().contains(string) ||
                $0.formattedDate.lowercased().contains(string)
            }
        }

        if !includeBetas {
            filteredFirmwares = filteredFirmwares.filter { !$0.beta }
        }

        if showCompatible {
            filteredFirmwares = filteredFirmwares.filter { $0.compatible }
        }

        return filteredFirmwares
    }
    private var filteredInstallers: [Installer] {
        var filteredInstallers: [Installer] = installers

        if !searchString.isEmpty {
            let string: String = searchString.lowercased()
            filteredInstallers = filteredInstallers.filter {
                $0.name.lowercased().contains(string) ||
                $0.version.lowercased().contains(string) ||
                $0.build.lowercased().contains(string) ||
                $0.date.lowercased().contains(string)
            }
        }

        if !includeBetas {
            filteredInstallers = filteredInstallers.filter { !$0.beta }
        }

        if showCompatible {
            filteredInstallers = filteredInstallers.filter { $0.compatible }
        }

        return filteredInstallers
    }
    private let width: CGFloat = 480
    private let height: CGFloat = 720

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(downloadType: $downloadType)
            Divider()
            if downloadType == .firmware && filteredFirmwares.isEmpty || downloadType == .installer && filteredInstallers.isEmpty {
                EmptyCollectionView("No macOS \(downloadType.description)s found!\n\nಥ_ಥ")
            } else {
                List {
                    ForEach(releaseNames(for: downloadType), id: \.self) { releaseName in
                        Section(header: Text(releaseName)) {
                            switch downloadType {
                            case .firmware:
                                ForEach(filteredFirmwares(for: releaseName)) { firmware in
                                    ListRowFirmware(firmware: firmware, savePanel: $savePanel, tasksInProgress: $tasksInProgress, taskManager: taskManager)
                                        .tag(firmware)
                                }
                            case .installer:
                                ForEach(filteredInstallers(for: releaseName)) { installer in
                                    ListRowInstaller(installer: installer, openPanel: $openPanel, tasksInProgress: $tasksInProgress, taskManager: taskManager)
                                        .tag(installer)
                                }
                            }
                        }
                    }
                }
            }
            Divider()
            FooterView(includeBetas: $includeBetas, showCompatible: $showCompatible, downloadType: downloadType, firmwares: $firmwares, installers: $installers)
        }
        .frame(width: width, height: height)
        .toolbar {
            Button {
                refresh()
            } label: {
                Label("Refresh", systemImage: "arrow.clockwise")
                    .foregroundColor(.accentColor)
            }
            .help("Refresh")
        }
        .searchable(text: $searchString)
        .sheet(isPresented: $refreshing) {
            RefreshView(firmwares: $firmwares, installers: $installers)
        }
        .onAppear {
            refresh()
        }
    }

    private func refresh() {
        refreshing = true
    }

    private func releaseNames(for type: DownloadType) -> [String] {

        var releaseNames: [String] = []

        switch type {
        case .firmware:

            for firmware in filteredFirmwares {

                let releaseName: String = firmware.name.replacingOccurrences(of: " beta", with: "")

                if !releaseNames.contains(releaseName) {
                    releaseNames.append(releaseName)
                }
            }
        case .installer:

            for installer in filteredInstallers {

                let releaseName: String = installer.name.replacingOccurrences(of: " beta", with: "")

                if !releaseNames.contains(releaseName) {
                    releaseNames.append(releaseName)
                }
            }
        }

        return releaseNames
    }

    private func filteredFirmwares(for releaseName: String) -> [Firmware] {
        filteredFirmwares.filter { $0.name.replacingOccurrences(of: " beta", with: "") == releaseName }
    }

    private func filteredInstallers(for releaseName: String) -> [Installer] {
        filteredInstallers.filter { $0.name.replacingOccurrences(of: " beta", with: "") == releaseName }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(refreshing: .constant(false), tasksInProgress: .constant(false))
    }
}
