//
//  SettingsInstallersView.swift
//  Mist
//
//  Created by Nindi Gill on 16/6/2022.
//

import SwiftUI

struct SettingsInstallersView: View {
    @AppStorage("cacheDownloads") private var cacheDownloads: Bool = false
    @State private var catalogRows: [CatalogRow] = []
    @State private var selectedCatalogRow: CatalogRow?
    private let cacheDownloadsDefault: Bool = false
    private var defaultCatalogRows: [CatalogRow] = Catalog.urls.map { CatalogRow(url: $0) }
    private let imageName: String = "Installer"
    private let title: String = "Installers"
    private let description: String = "macOS Installers are a collection of files that can be used to build macOS Installer **Applications**, **Disk Images**, **ISOs** and **Packages**."

    var body: some View {
        VStack(alignment: .leading) {
            SettingsHeaderView(imageName: imageName, title: title, description: description, fade: .constant(false))
            PaddedDivider()
            SettingsInstallersCacheView(enabled: $cacheDownloads)
            PaddedDivider()
            SettingsInstallersCatalogsView(catalogRows: $catalogRows, selectedCatalogRow: $selectedCatalogRow)
            PaddedDivider()
            ResetToDefaultButton {
                reset()
            }
        }
        .padding()
        .onAppear {
            populateCatalogURLs()
        }
        .onChange(of: catalogRows) { catalogRows in
            UserDefaults.standard.setValue(catalogRows.map { $0.url }, forKey: "catalogURLs")
        }
    }

    private func populateCatalogURLs() {

        guard let urls: [String] = UserDefaults.standard.array(forKey: "catalogURLs") as? [String] else {
            catalogRows = defaultCatalogRows
            return
        }

        catalogRows = urls.map { CatalogRow(url: $0) }
    }

    private func reset() {
        cacheDownloads = cacheDownloadsDefault
        catalogRows = defaultCatalogRows
    }
}

struct SettingsInstallersView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsInstallersView()
    }
}
