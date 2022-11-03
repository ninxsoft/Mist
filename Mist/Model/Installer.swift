//
//  Installer.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import Foundation

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
            id: "012-06873",
            version: "12.4",
            build: "21F79",
            date: "2022-05-25",
            distributionURL: "https://swdist.apple.com/content/downloads/25/34/002-83506-A_0FVTHWXTXJ/9ipp8rhxtcyzjg9pdxekzznprkx48ssbo1/002-83506.English.dist",
            distributionSize: 7_242,
            packages: [],
            boardIDs: [],
            deviceIDs: [],
            unsupportedModelIdentifiers: []
        )
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
        [Package(url: distributionURL, size: distributionSize, integrityDataURL: nil, integrityDataSize: nil)] + packages.sorted { $0.filename < $1.filename }
    }
    var temporaryMountPointURL: URL {
        URL(fileURLWithPath: "/Volumes/Install \(name)")
    }
    var temporaryInstallerURL: URL {
        URL(fileURLWithPath: "/Volumes/\(id) Temp/Applications/Install \(name).app")
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
