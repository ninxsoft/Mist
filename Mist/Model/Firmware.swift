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
            version: "13.0",
            build: "22A380",
            shasum: "348f49da377d8c394672d1b2800d23452a1d6215",
            size: 12_197_669_257,
            url: "https://updates.cdn-apple.com/2022FallFCS/fullrestores/012-92188/2C38BCD1-2BFF-4A10-B358-94E8E28BE805/UniversalMac_13.0_22A380_Restore.ipsw",
            date: "2022-10-24T17:20:22Z",
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

        if version.range(of: "^14", options: .regularExpression) != nil {
            name = "macOS Sonoma"
        } else if version.range(of: "^13", options: .regularExpression) != nil {
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
    var tooltip: String {
        """
        Release: \(name)
        Version: \(version)
        Build Number: \(build)
        Release Date: \(formattedDate)
        Download Size: \(size.bytesString())
        """
    }

    /// Perform a lookup and retrieve a list of supported Firmware builds for this Mac.
    ///
    /// - Throws: An error if unable to retrieve a list of supported Firmware builds for this Mac.
    ///
    /// - Returns: An array of Firmware build strings.
    static func supportedBuilds() throws -> [String] {

        guard let architecture: Architecture = Hardware.architecture,
            architecture == .appleSilicon,
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
