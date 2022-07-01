//
//  Firmware.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import Foundation

struct Firmware: Decodable, Hashable, Identifiable {

    enum CodingKeys: String, CodingKey {
        case version = "version"
        case build = "buildid"
        case shasum = "sha1sum"
        case size = "size"
        case url = "url"
        case date = "releasedate"
        case signed = "signed"
        case compatible = "compatible"
    }

    static var example: Firmware {
        Firmware(
            version: "12.4",
            build: "21F79",
            shasum: "b5553b62da22e5fdbab2b56b6eb1fb74b58555ac",
            size: 13_837_340_777,
            url: "https://updates.cdn-apple.com/2022SpringFCS/fullrestores/012-06874/9CECE956-D945-45E2-93E9-4FFDC81BB49A/UniversalMac_12.4_21F79_Restore.ipsw",
            date: "2022-05-16T18:23:48Z",
            signed: true,
            compatible: true
        )
    }

    static var filenameDescription: String {
        """
        Use the following variables to set the filename dynamically. For example:
        - **%NAME%** will be replaced with **'\(Firmware.example.name)'**
        - **%VERSION%** will be replaced with **'\(Firmware.example.version)'**
        - **%BUILD%** will be replaced with **'\(Firmware.example.build)'**
        """
    }

    static let firmwaresURL: String = "https://api.ipsw.me/v3/firmwares.json/condensed"
    static let deviceURLTemplate: String = "https://api.ipsw.me/v4/device/MODELIDENTIFIER?type=ipsw"

    var id: String {
        "\(String.appIdentifier).\(version)-\(build)"
    }
    var name: String {

        var name: String = ""

        if version.range(of: "^13", options: .regularExpression) != nil {
            name = "macOS Ventura"
        } else if version.range(of: "^12", options: .regularExpression) != nil {
            name = "macOS Monterey"
        } else if version.range(of: "^11", options: .regularExpression) != nil {
            name = "macOS Big Sur"
        } else {
            name = "macOS \(version)"
        }

        name = beta ? "\(name) beta" : name
        return name
    }
    let version: String
    let build: String
    let shasum: String
    let size: UInt64
    let url: String
    let date: String
    let signed: Bool
    let compatible: Bool
    var formattedDate: String {
        String(date.prefix(10))
    }
    var beta: Bool {
        build.range(of: "[a-z]$", options: .regularExpression) != nil
    }
    var imageName: String {
        name.replacingOccurrences(of: " beta", with: "")
    }
    var dictionary: [String: Any] {
        [
            "name": name,
            "version": version,
            "build": build,
            "size": size,
            "url": url,
            "date": date,
            "signed": signed,
            "compatible": compatible,
            "beta": beta
        ]
    }

    /// Perform a lookup and retrieve a list of supported Firmware builds for this Mac.
    ///
    /// - Throws: An error if unable to retrieve a list of supported Firmware builds for this Mac.
    ///
    /// - Returns: An array of Firmware build strings.
    static func supportedBuilds() throws -> [String] {

        guard let architecture: String = Hardware.architecture,
            architecture.contains("arm64"),
            let modelIdentifier: String = Hardware.modelIdentifier,
            let url: URL = URL(string: Firmware.deviceURLTemplate.replacingOccurrences(of: "MODELIDENTIFIER", with: modelIdentifier)) else {
            return []
        }

        let string: String = try String(contentsOf: url)

        guard let data: Data = string.data(using: .utf8),
            let dictionary: [String: Any] = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let array: [[String: Any]] = dictionary["firmwares"] as? [[String: Any]] else {
            return []
        }

        return array.compactMap { $0["buildid"] as? String }
    }
}

extension Firmware: Equatable {

    static func == (lhs: Firmware, rhs: Firmware) -> Bool {
        lhs.version == rhs.version && lhs.build == rhs.build
    }
}
