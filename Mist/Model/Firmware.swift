//
//  Firmware.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import Foundation

struct Firmware: Decodable, Hashable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case version
        case build = "buildid"
        case shasum = "sha1sum"
        case size
        case url
        case date = "releasedate"
        case signed
        case compatible
    }

    static var example: Firmware {
        Firmware(
            version: "26.0",
            build: "25A354",
            shasum: "4f724c214e6925a450a38ced592bfadaccbae696",
            size: 18_267_586_270,
            url: "https://updates.cdn-apple.com/2025FallFCS/fullrestores/093-37622/CE01FAB2-7F26-48EE-AEE4-5E57A7F6D8BB/UniversalMac_26.0_25A354_Restore.ipsw",
            date: "2025-09-15T17:27:42Z",
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

        if version.range(of: "^26", options: .regularExpression) != nil {
            name = "macOS Tahoe"
        } else if version.range(of: "^15", options: .regularExpression) != nil {
            name = "macOS Sequoia"
        } else if version.range(of: "^14", options: .regularExpression) != nil {
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
    static func supportedBuilds() async throws -> [String] {
        guard
            let architecture: Architecture = Hardware.architecture,
            architecture == .appleSilicon,
            let modelIdentifier: String = Hardware.modelIdentifier,
            let url: URL = URL(string: Firmware.deviceURLTemplate.replacingOccurrences(of: "MODELIDENTIFIER", with: modelIdentifier)) else {
            return []
        }

        let (data, _): (Data, URLResponse) = try await URLSession.shared.data(from: url)

        guard
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
