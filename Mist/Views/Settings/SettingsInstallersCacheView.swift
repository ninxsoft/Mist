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
    @State private var buttonClicked: Bool = false
    @State private var openPanel: NSOpenPanel = NSOpenPanel()

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading) {
                    Toggle(isOn: $cacheDownloads) {
                        Text("Cache downloads")
                    }
                    FooterText("Speed up future operations by caching a local copy of macOS Installer files.")
                }
                Spacer()
                Button("Select...") {
                    selectCacheDirectory()
                }
                .disabled(!cacheDownloads)
            }
            PathControl(path: $cacheDirectory)
                .disabled(true)
            HStack(alignment: .firstTextBaseline) {
                FooterText("Cache directory currently contains \(cacheSize.bytesString()) of data.")
                Spacer()
                Button("Empty Cache...") {
                    buttonClicked.toggle()
                }
                .disabled(cacheSize == 0)
            }
        }
        .onAppear {
            retrieveCacheSize()
        }
        .onChange(of: cacheDirectory) { _ in
            retrieveCacheSize()
        }
        .alert(isPresented: $buttonClicked) {
            Alert(
                title: Text("Empty Cache Directory?"),
                message: Text("Emptying the cache directory will free up \(cacheSize.bytesString())."),
                primaryButton: .cancel(),
                secondaryButton: .destructive(Text("Empty")) { emptyCache() ; retrieveCacheSize() }
            )
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

    private func retrieveCacheSize() {

        let url: URL = URL(fileURLWithPath: cacheDirectory)
        var isDirectory: ObjCBool = false

        do {
            if !FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            }

            cacheSize = try FileManager.default.sizeOfDirectory(at: url)
        } catch {
            print(error.localizedDescription)
        }
    }

    private func emptyCache() {

        do {
            let paths: [String] = try FileManager.default.contentsOfDirectory(atPath: cacheDirectory)

            for path in paths {
                let url: URL = URL(fileURLWithPath: cacheDirectory + "/" + path)
                try FileManager.default.removeItem(at: url)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct SettingsInstallersCacheView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsInstallersCacheView(cacheDownloads: .constant(true), cacheDirectory: .constant(.cacheDirectory))
    }
}
