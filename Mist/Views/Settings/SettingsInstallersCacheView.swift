//
//  SettingsInstallersCacheView.swift
//  Mist
//
//  Created by Nindi Gill on 17/6/2022.
//

import SwiftUI

struct SettingsInstallersCacheView: View {
    @Binding var enabled: Bool
    @State private var cacheSize: String = ""
    @State private var buttonClicked: Bool = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Toggle(isOn: $enabled) {
                    Text("Cache downloads")
                }
                FooterText("Speed up future operations by caching a local copy of macOS Installer files.")
            }
            Spacer()
            VStack {
                Button("Empty Cache...") {
                    buttonClicked.toggle()
                }
                FooterText(cacheSize)
            }
        }
        .onAppear {
            getCacheSize()
        }
        .alert(isPresented: $buttonClicked) {
            Alert(
                title: Text("Empty Cache Directory?"),
                message: Text("Emptying the cache directory will free up \(cacheSize)."),
                primaryButton: .cancel(),
                secondaryButton: .destructive(Text("Empty")) { emptyCache() ; getCacheSize() }
            )
        }
    }

    private func getCacheSize() {

        let url: URL = URL(fileURLWithPath: .cacheDirectory)
        var isDirectory: ObjCBool = false

        do {
            if !FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            }

            let size: UInt64 = try FileManager.default.sizeOfDirectory(at: url)
            cacheSize = size.bytesString()
        } catch {
            print(error.localizedDescription)
        }
    }

    private func emptyCache() {

        do {
            let paths: [String] = try FileManager.default.contentsOfDirectory(atPath: .cacheDirectory)

            for path in paths {
                let url: URL = URL(fileURLWithPath: .cacheDirectory + "/" + path)
                try FileManager.default.removeItem(at: url)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct SettingsInstallersCacheView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsInstallersCacheView(enabled: .constant(true))
    }
}
