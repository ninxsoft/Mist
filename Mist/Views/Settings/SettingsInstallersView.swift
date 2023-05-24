//
//  SettingsInstallersView.swift
//  Mist
//
//  Created by Nindi Gill on 16/6/2022.
//

import SwiftUI

struct SettingsInstallersView: View {
    @AppStorage("cacheDownloads")
    private var cacheDownloads: Bool = false
    @AppStorage("cacheDirectory")
    private var cacheDirectory: String = .cacheDirectory
    @State private var catalogs: [Catalog] = []
    private let cacheDownloadsDefault: Bool = false
    private let cacheDirectoryDefault: String = .cacheDirectory
    private let defaultCatalogs: [Catalog] = CatalogType.allCases.map { Catalog(type: $0, standard: true, customerSeed: false, developerSeed: false, publicSeed: false) }
    private let imageName: String = "Installer"
    private let title: String = "Installers"
    private let description: String = "macOS Installers are a collection of files that can be used to build macOS Installer **Applications**, **Disk Images**, **ISOs** and **Packages**."

    var body: some View {
        VStack(alignment: .leading) {
            SettingsHeaderView(imageName: imageName, title: title, description: description)
            PaddedDivider()
            SettingsInstallersCacheView(cacheDownloads: $cacheDownloads, cacheDirectory: $cacheDirectory)
            PaddedDivider()
            SettingsInstallersCatalogsView(catalogs: $catalogs)
            PaddedDivider()
            ResetToDefaultButton {
                reset()
            }
        }
        .padding()
        .onAppear {
            catalogs = getCatalogs()
        }
        .onChange(of: catalogs) { catalogs in
            UserDefaults.standard.setValue(catalogs.map { $0.dictionary() }, forKey: "catalogs")
        }
    }

    private func getCatalogs() -> [Catalog] {

        guard let array: [[String: Any]] = UserDefaults.standard.array(forKey: "catalogs") as? [[String: Any]] else {
            return defaultCatalogs
        }

        do {
            var catalogs: [Catalog] = try JSONDecoder().decode([Catalog].self, from: JSONSerialization.data(withJSONObject: array))
            let catalogTypes: [CatalogType] = catalogs.map { $0.type }

            for catalogType in CatalogType.allCases where !catalogTypes.contains(catalogType) {
                let catalog: Catalog = Catalog(type: catalogType, standard: true, customerSeed: false, developerSeed: false, publicSeed: false)
                catalogs.append(catalog)
            }

            return catalogs.sorted { $0.type < $1.type }
        } catch {
            return defaultCatalogs
        }
    }

    private func reset() {
        cacheDownloads = cacheDownloadsDefault
        cacheDirectory = cacheDirectoryDefault
        catalogs = defaultCatalogs
    }
}

struct SettingsInstallersView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsInstallersView()
    }
}
