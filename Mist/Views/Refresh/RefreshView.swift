//
//  RefreshView.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import SwiftUI

// swiftlint:disable:next type_body_length
struct RefreshView: View {
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    @Binding var firmwares: [Firmware]
    @Binding var installers: [Installer]
    @State private var firmwaresState: RefreshState = .pending
    @State private var installersState: RefreshState = .pending
    private let width: CGFloat = 200
    private var height: CGFloat {
        firmwaresState == .warning ? 230 : 200
    }
    private var buttonText: String {
        [.pending, .inProgress].contains(firmwaresState) || [.pending, .inProgress].contains(installersState) ? "Cancel" : "Close"
    }

    var body: some View {
        VStack(spacing: 0) {
            Text("Refreshing")
                .font(.title2)
                .padding(.vertical)
            Divider()
            Spacer()
            VStack {
                RefreshRowView(image: "memorychip", title: "Firmwares...", state: $firmwaresState)
                if firmwaresState == .warning {
                    Text("The Firmwares API is being updated, please try again shortly.")
                        .font(.caption)
                }
                RefreshRowView(image: "desktopcomputer.and.arrow.down", title: "Installers...", state: $installersState)
            }
            .padding(.horizontal)
            Spacer()
            Divider()
            Button(buttonText) {
                presentationMode.wrappedValue.dismiss()
            }
            .padding(.vertical)
        }
        .interactiveDismissDisabled()
        .frame(width: width, height: height)
        .onAppear {
            Task {
                await refresh()
            }
        }
    }

    private func refresh() async {
        let nanoseconds: UInt64 = 500_000_000
        var successful: Bool = true

        firmwaresState = .inProgress

        do {
            firmwares = try retrieveFirmwares()
            try? await Task.sleep(nanoseconds: nanoseconds)
            firmwaresState = .complete
        } catch {
            successful = false
            try? await Task.sleep(nanoseconds: nanoseconds)

            if let error = error as? MistError,
                error == .missingDevicesKey {
                withAnimation {
                    firmwaresState = .warning
                }
            } else {
                firmwaresState = .error
            }
        }

        installersState = .inProgress

        do {
            installers = try retrieveInstallers()
            try? await Task.sleep(nanoseconds: nanoseconds)
            installersState = .complete
        } catch {
            successful = false
            try? await Task.sleep(nanoseconds: nanoseconds)
            installersState = .error
        }

        if successful {
            try? await Task.sleep(nanoseconds: nanoseconds)
            presentationMode.wrappedValue.dismiss()
        }
    }

    private func retrieveFirmwares() throws -> [Firmware] {

        var firmwares: [Firmware] = []

        guard let firmwaresURL: URL = URL(string: Firmware.firmwaresURL) else {
            throw MistError.invalidURL(Firmware.firmwaresURL)
        }

        let string: String = try String(contentsOf: firmwaresURL, encoding: .utf8)

        guard let data: Data = string.data(using: .utf8),
            let dictionary: [String: Any] = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw MistError.invalidData
        }

        guard let devices: [String: Any] = dictionary["devices"] as? [String: Any] else {
            throw MistError.missingDevicesKey
        }

        let supportedBuilds: [String] = try Firmware.supportedBuilds()

        for (identifier, device) in devices {

            guard identifier.contains("Mac"),
                let device: [String: Any] = device as? [String: Any],
                let firmwaresArray: [[String: Any]] = device["firmwares"] as? [[String: Any]] else {
                continue
            }

            for var firmwareDictionary in firmwaresArray {

                if let url: String = firmwareDictionary["url"] as? String,
                    url.contains("http://updates-http.cdn-apple.com") {
                    firmwareDictionary["url"] = url.replacingOccurrences(of: "http://updates-http.cdn-apple.com", with: "https://updates.cdn-apple.com")
                }

                firmwareDictionary["compatible"] = supportedBuilds.contains(firmwareDictionary["buildid"] as? String ?? "")
                let firmwareData: Data = try JSONSerialization.data(withJSONObject: firmwareDictionary, options: .prettyPrinted)
                let firmware: Firmware = try JSONDecoder().decode(Firmware.self, from: firmwareData)

                if !firmwares.contains(where: { $0 == firmware }) {
                    firmwares.append(firmware)
                }
            }
        }

        firmwares.sort {
            $0.version == $1.version ?
            ($0.build.count == $1.build.count ? $0.build > $1.build : $0.build.count > $1.build.count) :
            $0.version > $1.version
        }
        return firmwares
    }

    private func retrieveInstallers() throws -> [Installer] {
        var installers: [Installer] = []
        let catalogURLs: [String] = getCatalogURLs()

        for catalogURL in catalogURLs {

            guard let url: URL = URL(string: catalogURL) else {
                continue
            }

            do {
                let string: String = try String(contentsOf: url, encoding: .utf8)

                guard let data: Data = string.data(using: .utf8) else {
                    continue
                }

                var format: PropertyListSerialization.PropertyListFormat = .xml

                guard let catalog: [String: Any] = try PropertyListSerialization.propertyList(from: data, options: [.mutableContainers], format: &format) as? [String: Any],
                    let productsDictionary: [String: Any] = catalog["Products"] as? [String: Any] else {
                    continue
                }

                installers.append(contentsOf: getInstallers(from: productsDictionary).filter { !installers.map { $0.id }.contains($0.id) })
            } catch {
                continue
            }
        }

        installers.append(contentsOf: Installer.legacyInstallers)
        installers.sort {
            $0.version == $1.version ?
            ($0.build.count == $1.build.count ? $0.build > $1.build : $0.build.count > $1.build.count) :
            $0.version.compare($1.version, options: .numeric) == .orderedDescending
        }

        guard !installers.isEmpty else {
            throw MistError.invalidData
        }

        return installers
    }

    private func getCatalogURLs() -> [String] {

        var catalogURLs: [String] = []
        var catalogs: [Catalog] = []
        let defaultCatalogs: [Catalog] = CatalogType.allCases.map { Catalog(type: $0, standard: true, customerSeed: false, developerSeed: false, publicSeed: false) }

        if let array: [[String: Any]] = UserDefaults.standard.array(forKey: "catalogs") as? [[String: Any]] {
            do {
                catalogs = try JSONDecoder().decode([Catalog].self, from: JSONSerialization.data(withJSONObject: array))
                let catalogTypes: [CatalogType] = catalogs.map { $0.type }

                for catalogType in CatalogType.allCases where !catalogTypes.contains(catalogType) {
                    let catalog: Catalog = Catalog(type: catalogType, standard: true, customerSeed: false, developerSeed: false, publicSeed: false)
                    catalogs.append(catalog)
                }
            } catch {
                catalogs = defaultCatalogs
            }
        } else {
            catalogs = defaultCatalogs
        }

        for catalog in catalogs {
            if catalog.standard {
                catalogURLs.append(catalog.type.url(for: .standard))
            }

            if catalog.customerSeed {
                catalogURLs.append(catalog.type.url(for: .customer))
            }

            if catalog.developerSeed {
                catalogURLs.append(catalog.type.url(for: .developer))
            }

            if catalog.publicSeed {
                catalogURLs.append(catalog.type.url(for: .public))
            }
        }

        return catalogURLs
    }

    private func getInstallers(from dictionary: [String: Any]) -> [Installer] {

        var installers: [Installer] = []
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        for (key, value) in dictionary {

            guard var value: [String: Any] = value as? [String: Any],
                let date: Date = value["PostDate"] as? Date,
                let extendedMetaInfo: [String: Any] = value["ExtendedMetaInfo"] as? [String: Any],
                extendedMetaInfo["InstallAssistantPackageIdentifiers"] as? [String: Any] != nil,
                let distributions: [String: Any] = value["Distributions"] as? [String: Any],
                let distributionURL: String = distributions["English"] as? String,
                let url: URL = URL(string: distributionURL) else {
                continue
            }

            do {
                let string: String = try String(contentsOf: url, encoding: .utf8)

                guard let name: String = nameFromDistribution(string),
                    let version: String = versionFromDistribution(string),
                    let build: String = buildFromDistribution(string),
                    !name.isEmpty && !version.isEmpty && !build.isEmpty else {
                    continue
                }

                let boardIDs: [String] = boardIDsFromDistribution(string)
                let deviceIDs: [String] = deviceIDsFromDistribution(string)
                let unsupportedModelIdentifiers: [String] = unsupportedModelIdentifiersFromDistribution(string)

                value["Identifier"] = key
                value["Name"] = name
                value["Version"] = version
                value["Build"] = build
                value["BoardIDs"] = boardIDs
                value["DeviceIDs"] = deviceIDs
                value["UnsupportedModelIdentifiers"] = unsupportedModelIdentifiers
                value["PostDate"] = dateFormatter.string(from: date)
                value["DistributionURL"] = distributionURL
                value["DistributionSize"] = string.count

                // JSON object creation freaks out with the default DeferredSUEnablementDate date format
                value.removeValue(forKey: "DeferredSUEnablementDate")

                let installerData: Data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                let installer: Installer = try JSONDecoder().decode(Installer.self, from: installerData)
                installers.append(installer)
            } catch {
                continue
            }
        }

        return installers
    }

    private func nameFromDistribution(_ string: String) -> String? {

        guard string.contains("suDisabledGroupID") else {
            return nil
        }

        return string.replacingOccurrences(of: "^[\\s\\S]*suDisabledGroupID=\"", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\"[\\s\\S]*$", with: "", options: .regularExpression)
            .replacingOccurrences(of: "Install ", with: "")
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

    private func boardIDsFromDistribution(_ string: String) -> [String] {

        guard string.contains("supportedBoardIDs") || string.contains("boardIds") else {
            return []
        }

        return string.replacingOccurrences(of: "^[\\s\\S]*(supportedBoardIDs|boardIds) = \\[", with: "", options: .regularExpression)
            .replacingOccurrences(of: ",?\\];[\\s\\S]*$", with: "", options: .regularExpression)
            .replacingOccurrences(of: "'", with: "")
            .replacingOccurrences(of: " ", with: "")
            .components(separatedBy: ",")
            .sorted()
    }

    private func deviceIDsFromDistribution(_ string: String) -> [String] {

        guard string.contains("supportedDeviceIDs") else {
            return []
        }

        return string.replacingOccurrences(of: "^[\\s\\S]*supportedDeviceIDs = \\[", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\\];[\\s\\S]*$", with: "", options: .regularExpression)
            .replacingOccurrences(of: "'", with: "")
            .replacingOccurrences(of: " ", with: "")
            .uppercased()
            .components(separatedBy: ",")
            .sorted()
    }

    private func unsupportedModelIdentifiersFromDistribution(_ string: String) -> [String] {

        guard string.contains("nonSupportedModels") else {
            return []
        }

        return string.replacingOccurrences(of: "^[\\s\\S]*nonSupportedModels = \\[", with: "", options: .regularExpression)
            .replacingOccurrences(of: ",?\\];[\\s\\S]*$", with: "", options: .regularExpression)
            .replacingOccurrences(of: "','", with: "'|'")
            .replacingOccurrences(of: "'", with: "")
            .components(separatedBy: "|")
            .sorted()
    }
}

struct RefreshView_Previews: PreviewProvider {
    static var previews: some View {
        RefreshView(firmwares: .constant([.example]), installers: .constant([.example]))
    }
}
