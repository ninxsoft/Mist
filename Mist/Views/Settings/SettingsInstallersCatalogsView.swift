//
//  SettingsInstallersCatalogsView.swift
//  Mist
//
//  Created by Nindi Gill on 17/6/2022.
//

import SwiftUI

struct SettingsInstallersCatalogsView: View {
    @Binding var catalogRows: [CatalogRow]
    @Binding var selectedCatalogRow: CatalogRow?
    private let length: CGFloat = 16
    private let height: CGFloat = 200

    var body: some View {
        VStack(alignment: .leading) {
            Text("Catalog URLs:")
            FooterText("Apple Software Update Catalogs are used to determine all available macOS Installers.")
            List(selection: $selectedCatalogRow) {
                ForEach($catalogRows) { catalogRow in
                    HStack {
                        ScaledSystemImage(systemName: "line.3.horizontal", length: length)
                            .foregroundColor(.secondary)
                        TextEditor(text: catalogRow.url)
                    }
                }
                .onMove { indexSet, offset in
                    catalogRows.move(fromOffsets: indexSet, toOffset: offset)
                }
                .onDelete { indexSet in
                    catalogRows.remove(atOffsets: indexSet)
                }
            }
            .frame(minHeight: height)
            HStack {
                Spacer()
                Button("Add") {
                    addCatalog()
                }
            }
        }
    }

    private func addCatalog() {
        catalogRows.append(CatalogRow(url: "https://"))
    }
}

struct SettingsInstallersCatalogsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsInstallersCatalogsView(catalogRows: .constant([.example]), selectedCatalogRow: .constant(.example))
    }
}
