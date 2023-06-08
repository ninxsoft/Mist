//
//  SettingsInstallersCatalogsView.swift
//  Mist
//
//  Created by Nindi Gill on 17/6/2022.
//

import SwiftUI

struct SettingsInstallersCatalogsView: View {
    @Binding var catalogs: [Catalog]
    // swiftlint:disable:next line_length
    private let description: String = "Apple Software Update Catalogs are used to determine available macOS Installers.\n\n- **Standard:** The default catalog that ships with macOS\n- **Customer Seed:** The catalog available as part of the [AppleSeed Program](https://appleseed.apple.com/)\n- **Developer Seed:** The catalog available as part of the [Apple Developer Program](https://developer.apple.com/programs/)\n- **Public Seed:** The catalog available as part of the [Apple Beta Software Program](https://beta.apple.com/)\n\n**Note:** Catalogs from the Seed Programs may contain beta / unreleased versions of macOS. Ensure you are a member of these programs before proceeding."
    private let height: CGFloat = 126
    private let width: CGFloat = 150
    private let length: CGFloat = 16

    var body: some View {
        VStack(alignment: .leading) {
            Text("Software Update Catalogs:")
            FooterText(description)
            Table(catalogs) {
                TableColumn("") { catalog in
                    ScaledImage(name: catalog.type.imageName, length: length)
                }
                .width(length)
                TableColumn("Catalog Type") { catalog in
                    Text(catalog.type.description)
                }
                .width(width)
                TableColumn(CatalogSeedType.standard.description) { catalog in
                    toggle(.standard, using: catalog)
                }
                TableColumn(CatalogSeedType.customer.description) { catalog in
                    toggle(.customer, using: catalog)
                }
                TableColumn(CatalogSeedType.developer.description) { catalog in
                    toggle(.developer, using: catalog)
                }
                TableColumn(CatalogSeedType.public.description) { catalog in
                    toggle(.public, using: catalog)
                }
            }
            .tableStyle(.bordered)
            .frame(minHeight: height, maxHeight: height)
        }
    }

    private func toggle(_ catalogSeedType: CatalogSeedType, using catalog: Catalog) -> some View {
        Toggle(catalogSeedType.description, isOn: Binding<Bool>(
            get: {
                switch catalogSeedType {
                case .standard:
                    return catalog.standard
                case .customer:
                    return catalog.customerSeed
                case .developer:
                    return catalog.developerSeed
                case .public:
                    return catalog.publicSeed
                }
            },
            set: {
                guard let index: Int = catalogs.firstIndex(where: { $0.id == catalog.id }) else {
                    return
                }

                switch catalogSeedType {
                case .standard:
                    catalogs[index].standard = $0
                case .customer:
                    catalogs[index].customerSeed = $0
                case .developer:
                    catalogs[index].developerSeed = $0
                case .public:
                    catalogs[index].publicSeed = $0
                }
            }
        ))
        .labelsHidden()
    }
}

struct SettingsInstallersCatalogsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsInstallersCatalogsView(catalogs: .constant([.example]))
    }
}
