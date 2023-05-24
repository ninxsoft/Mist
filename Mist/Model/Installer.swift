//
//  Installer.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import Foundation

// swiftlint:disable:next type_body_length
struct Installer: Decodable, Hashable, Identifiable {

    enum CodingKeys: String, CodingKey {
        case id = "Identifier"
        case version = "Version"
        case build = "Build"
        case date = "PostDate"
        case distributionURL = "DistributionURL"
        case distributionSize = "DistributionSize"
        case packages = "Packages"
        case boardIDs = "BoardIDs"
        case deviceIDs = "DeviceIDs"
        case unsupportedModelIdentifiers = "UnsupportedModelIdentifiers"
    }

    static var example: Installer {
        Installer(
            id: "012-92138",
            version: "13.0",
            build: "22A380",
            date: "2022-10-25",
            distributionURL: "https://swdist.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/012-92138.English.dist",
            distributionSize: 7_467,
            packages: [
                Package(
                    url: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/MajorOSInfo.pkg",
                    size: 1_334_737,
                    integrityDataURL: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/MajorOSInfo.pkg.integrityDataV1",
                    integrityDataSize: 104
                ),
                Package(
                    url: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/InstallAssistant.pkg",
                    size: 12_151_608_300,
                    integrityDataURL: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/InstallAssistant.pkg.integrityDataV1",
                    integrityDataSize: 41_792
                ),
                Package(
                    url: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/BuildManifest.plist",
                    size: 3_355_762,
                    integrityDataURL: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/BuildManifest.plist.integrityDataV1",
                    integrityDataSize: 104
                ),
                Package(
                    url: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/InstallInfo.plist",
                    size: 181,
                    integrityDataURL: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/InstallInfo.plist.integrityDataV1",
                    integrityDataSize: 104
                ),
                Package(
                    url: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/UpdateBrain.zip",
                    size: 3_450_528,
                    integrityDataURL: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/UpdateBrain.zip.integrityDataV1",
                    integrityDataSize: 104
                ),
                Package(
                    url: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/Info.plist",
                    size: 5_042,
                    integrityDataURL: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/Info.plist.integrityDataV1",
                    integrityDataSize: 104
                )
            ],
            boardIDs: [
                "Mac-0CFF9C7C2B63DF8D",
                "Mac-112818653D3AABFC",
                "Mac-1E7E29AD0135F9BC",
                "Mac-226CB3C6A851A671",
                "Mac-27AD2F918AE68F61",
                "Mac-4B682C642B45593E",
                "Mac-53FDB3D8DB8CA971",
                "Mac-551B86E5744E2388",
                "Mac-5F9802EFE386AA28",
                "Mac-63001698E7A34814",
                "Mac-77F17D7DA9285301",
                "Mac-7BA5B2D9E42DDD94",
                "Mac-7BA5B2DFE22DDD8C",
                "Mac-827FAC58A8FDFA22",
                "Mac-827FB448E656EC26",
                "Mac-937A206F2EE63C01",
                "Mac-A61BADE1FDAD7B05",
                "Mac-AA95B1DDAB278B95",
                "Mac-AF89B6D9451A490B",
                "Mac-B4831CEBD52A0C4C",
                "Mac-BE088AF8C5EB4FA2",
                "Mac-CAD6701F7CEA0921",
                "Mac-CFF7D910A743CAAF",
                "Mac-E1008331FDC96864",
                "Mac-E7203C0F68AA0004",
                "Mac-EE2EBD4B90B839A8"
            ],
            deviceIDs: [
                "J132AP",
                "J137AP",
                "J140AAP",
                "J140KAP",
                "J152FAP",
                "J160AP",
                "J174AP",
                "J185AP",
                "J185FAP",
                "J213AP",
                "J214AP",
                "J214KAP",
                "J215AP",
                "J223AP",
                "J230AP",
                "J230KAP",
                "J274AP",
                "J293AP",
                "J313AP",
                "J314CAP",
                "J314SAP",
                "J316CAP",
                "J316SAP",
                "J375CAP",
                "J375DAP",
                "J413AP",
                "J456AP",
                "J457AP",
                "J493AP",
                "J680AP",
                "J780AP",
                "VMA2MACOSAP",
                "VMM-X86_64",
                "X589AMLUAP",
                "X86LEGACYAP"
            ],
            unsupportedModelIdentifiers: []
        )
    }

    static var legacyInstallers: [Installer] {
        [
            Installer(
                id: "10.12.6-16G29",
                version: "10.12.6",
                build: "16G29",
                date: "2017-07-15",
                distributionURL: "",
                distributionSize: 0,
                packages: [
                    Package(
                        url: "http://updates-http.cdn-apple.com/2019/cert/061-39476-20191023-48f365f4-0015-4c41-9f44-39d3d2aca067/InstallOS.dmg",
                        size: 5_007_882_126,
                        integrityDataURL: nil,
                        integrityDataSize: nil
                    )
                ],
                boardIDs: [],
                deviceIDs: [],
                unsupportedModelIdentifiers: []
            ),
            Installer(
                id: "10.11.6-15G31",
                version: "10.11.6",
                build: "15G31",
                date: "2016-05-18",
                distributionURL: "",
                distributionSize: 0,
                packages: [
                    Package(
                        url: "http://updates-http.cdn-apple.com/2019/cert/061-41424-20191024-218af9ec-cf50-4516-9011-228c78eda3d2/InstallMacOSX.dmg",
                        size: 6_204_629_298,
                        integrityDataURL: nil,
                        integrityDataSize: nil
                    )
                ],
                boardIDs: [],
                deviceIDs: [],
                unsupportedModelIdentifiers: []
            ),
            Installer(
                id: "10.10.5-14F27",
                version: "10.10.5",
                build: "14F27",
                date: "2015-08-05",
                distributionURL: "",
                distributionSize: 0,
                packages: [
                    Package(
                        url: "http://updates-http.cdn-apple.com/2019/cert/061-41343-20191023-02465f92-3ab5-4c92-bfe2-b725447a070d/InstallMacOSX.dmg",
                        size: 5_718_074_248,
                        integrityDataURL: nil,
                        integrityDataSize: nil
                    )
                ],
                boardIDs: [],
                deviceIDs: [],
                unsupportedModelIdentifiers: []
            ),
            Installer(
                id: "10.8.5-12F45",
                version: "10.8.5",
                build: "12F45",
                date: "2013-09-27",
                distributionURL: "",
                distributionSize: 0,
                packages: [
                    Package(
                        url: "https://updates.cdn-apple.com/2021/macos/031-0627-20210614-90D11F33-1A65-42DD-BBEA-E1D9F43A6B3F/InstallMacOSX.dmg",
                        size: 4_449_317_520,
                        integrityDataURL: nil,
                        integrityDataSize: nil
                    )
                ],
                boardIDs: [],
                deviceIDs: [],
                unsupportedModelIdentifiers: []
            ),
            Installer(
                id: "10.7.5-11G63",
                version: "10.7.5",
                build: "11G63",
                date: "2012-09-28",
                distributionURL: "",
                distributionSize: 0,
                packages: [
                    Package(
                        url: "https://updates.cdn-apple.com/2021/macos/041-7683-20210614-E610947E-C7CE-46EB-8860-D26D71F0D3EA/InstallMacOSX.dmg",
                        size: 4_720_237_409,
                        integrityDataURL: nil,
                        integrityDataSize: nil
                    )
                ],
                boardIDs: [],
                deviceIDs: [],
                unsupportedModelIdentifiers: []
            )
        ]
    }

    static var filenameDescription: String {
        """
        Use the following variables to set the filename dynamically. For example:
        - **%NAME%** will be replaced with **'\(Installer.example.name)'**
        - **%VERSION%** will be replaced with **'\(Installer.example.version)'**
        - **%BUILD%** will be replaced with **'\(Installer.example.build)'**
        """
    }

    static var packageDescription: String {
        """
        Use the following variables to set the identifier dynamically. For example:
        - **%NAME%** will be replaced with **'\(Installer.example.name)'**
        - **%VERSION%** will be replaced with **'\(Installer.example.version)'**
        - **%BUILD%** will be replaced with **'\(Installer.example.build)'**
        - Spaces will be replaced with hyphens **-**
        """
    }

    let id: String
    let version: String
    let build: String
    let date: String
    let distributionURL: String
    let distributionSize: Int
    let packages: [Package]
    let boardIDs: [String]
    let deviceIDs: [String]
    let unsupportedModelIdentifiers: [String]
    var name: String {

        var name: String = ""

        if version.range(of: "^13", options: .regularExpression) != nil {
            name = "macOS Ventura"
        } else if version.range(of: "^12", options: .regularExpression) != nil {
            name = "macOS Monterey"
        } else if version.range(of: "^11", options: .regularExpression) != nil {
            name = "macOS Big Sur"
        } else if version.range(of: "^10\\.15", options: .regularExpression) != nil {
            name = "macOS Catalina"
        } else if version.range(of: "^10\\.14", options: .regularExpression) != nil {
            name = "macOS Mojave"
        } else if version.range(of: "^10\\.13", options: .regularExpression) != nil {
            name = "macOS High Sierra"
        } else if version.range(of: "^10\\.12", options: .regularExpression) != nil {
            name = "macOS Sierra"
        } else if version.range(of: "^10\\.11", options: .regularExpression) != nil {
            name = "OS X El Capitan"
        } else if version.range(of: "^10\\.10", options: .regularExpression) != nil {
            name = "OS X Yosemite"
        } else if version.range(of: "^10\\.9", options: .regularExpression) != nil {
            name = "OS X Mavericks"
        } else if version.range(of: "^10\\.8", options: .regularExpression) != nil {
            name = "OS X Mountain Lion"
        } else if version.range(of: "^10\\.7", options: .regularExpression) != nil {
            name = "Mac OS X Lion"
        } else {
            name = "macOS \(version)"
        }

        name = beta ? "\(name) beta" : name
        return name
    }
    var compatible: Bool {
        // Board ID (Intel)
        if let boardID: String = Hardware.boardID,
            !boardIDs.isEmpty,
            !boardIDs.contains(boardID) {
            return false
        }

        // Device ID (Apple Silicon or Intel T2)
        // macOS Big Sur 11 or newer
        if version.range(of: "^1[1-9]\\.", options: .regularExpression) != nil,
            let deviceID: String = Hardware.deviceID,
            !deviceIDs.isEmpty,
            !deviceIDs.contains(deviceID) {
            return false
        }

        // Model Identifier (Apple Silicon or Intel)
        // macOS Catalina 10.15 or older
        if version.range(of: "^10\\.", options: .regularExpression) != nil {

            if let architecture: String = Hardware.architecture,
                architecture.contains("arm64") {
                return false
            }

            if let modelIdentifier: String = Hardware.modelIdentifier,
                !unsupportedModelIdentifiers.isEmpty,
                unsupportedModelIdentifiers.contains(modelIdentifier) {
                return false
            }
        }

        return true
    }
    var allDownloads: [Package] {
        (sierraOrOlder ? [] : [Package(url: distributionURL, size: distributionSize, integrityDataURL: nil, integrityDataSize: nil)]) + packages.sorted { $0.filename < $1.filename }
    }
    var temporaryDiskImageMountPointURL: URL {
        URL(fileURLWithPath: "/Volumes/\(id)")
    }
    var temporaryInstallerURL: URL {
        temporaryDiskImageMountPointURL.appendingPathComponent("/Applications/Install \(name).app")
    }
    var temporaryISOMountPointURL: URL {
        URL(fileURLWithPath: "/Volumes/Install \(name)")
    }
    var dictionary: [String: Any] {
        [
            "identifier": id,
            "name": name,
            "version": version,
            "build": build,
            "size": size,
            "date": date,
            "compatible": compatible,
            "distribution": distributionURL,
            "packages": packages.map { $0.dictionary },
            "beta": beta
        ]
    }
    var sierraOrOlder: Bool {
        version.range(of: "^10\\.([7-9]|1[0-2])\\.", options: .regularExpression) != nil
    }
    var catalinaOrNewer: Bool {
        bigSurOrNewer || version.range(of: "^10\\.15\\.", options: .regularExpression) != nil
    }
    var bigSurOrNewer: Bool {
        version.range(of: "^1[1-9]\\.", options: .regularExpression) != nil
    }
    var beta: Bool {
        build.range(of: "[a-z]$", options: .regularExpression) != nil
    }
    var imageName: String {
        name.replacingOccurrences(of: " beta", with: "")
    }
    var size: UInt64 {
        UInt64(packages.map { $0.size }.reduce(0, +))
    }
    var diskImageSize: Double {
        ceil(Double(size) / Double(UInt64.gigabyte)) + 1.5
    }
    var isoSize: Double {
        ceil(Double(size) / Double(UInt64.gigabyte)) + 1.5
    }
}

extension Installer: Equatable {

    static func == (lhs: Installer, rhs: Installer) -> Bool {
        lhs.version == rhs.version && lhs.build == rhs.build
    }
}
