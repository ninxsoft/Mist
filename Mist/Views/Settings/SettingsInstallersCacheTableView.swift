//
//  SettingsInstallersCacheTableView.swift
//  Mist
//
//  Created by Nindi Gill on 23/6/2023.
//

import SwiftUI

struct SettingsInstallersCacheTableView: View {
    var installers: [Installer]
    @Binding var selectedInstallerId: String?
    var cacheDownloads: Bool
    private let height: CGFloat = 126
    private let width: CGFloat = 150
    private let length: CGFloat = 16

    var body: some View {
        Table(installers, selection: $selectedInstallerId) {
            TableColumn("") { installer in
                ScaledImage(name: "Application - \(installer.version.isEmpty ? "macOS" : installer.imageName)", length: length)
            }
            .width(length)
            TableColumn("Release") { installer in
                Text(installer.version.isEmpty ? installer.id : installer.name)
            }
            .width(width)
            TableColumn("Version") { installer in
                Text(installer.version.isEmpty ? "Unknown" : installer.version)
            }
            TableColumn("Build") { installer in
                Text(installer.build.isEmpty ? "Unknown" : installer.build)
            }
            TableColumn("Size") { installer in
                Text(installer.size.bytesString())
            }
        }
        .tableStyle(.bordered)
        .frame(minHeight: height, maxHeight: height)
        .disabled(!cacheDownloads)
        .opacity(cacheDownloads ? 1 : 0.5)
    }
}

struct SettingsInstallersCacheTableView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsInstallersCacheTableView(installers: [.example], selectedInstallerId: .constant(nil), cacheDownloads: true)
    }
}
