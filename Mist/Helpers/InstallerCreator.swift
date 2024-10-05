//
//  InstallerCreator.swift
//  Mist
//
//  Created by Nindi Gill on 21/6/2022.
//

import Foundation
import SecureXPC

/// Helper Struct used to create macOS Installers.
enum InstallerCreator {
    /// Creates a recently downloaded macOS Installer.
    ///
    /// - Parameters:
    ///   - installer:      The selected macOS Installer that was downloaded.
    ///   - mountPoint:     The URL of the directory mount point.
    ///   - cacheDirectory: The cache directory storing all macOS Installer components.
    ///
    /// - Throws: A `MistError` if the downloaded macOS Installer fails to generate.
    static func create(_ installer: Installer, mountPoint: URL, cacheDirectory: String) async throws {
        let packageURL: URL

        if installer.sierraOrOlder {
            guard let package: Package = installer.packages.first else {
                throw MistError.invalidData
            }

            packageURL = URL(fileURLWithPath: "/Volumes/Install \(installer.name)").appendingPathComponent(package.filename.replacingOccurrences(of: ".dmg", with: ".pkg"))
        } else {
            guard let url: URL = URL(string: installer.distributionURL) else {
                throw MistError.invalidURL(installer.distributionURL)
            }

            packageURL = URL(fileURLWithPath: cacheDirectory).appendingPathComponent(installer.id).appendingPathComponent(url.lastPathComponent)
        }

        try await DirectoryRemover.remove(installer.temporaryInstallerURL)

        var argumentsArrays: [[String]] = [
            ["installer", "-pkg", packageURL.path, "-target", mountPoint.path]
        ]

        // workaround for macOS High Sierra 10.13, macOS Mojave 10.14 and macOS Catalina 10.15
        if installer.highSierraOrNewer, !installer.bigSurOrNewer {
            argumentsArrays += [
                ["ditto", "/Applications/Install \(installer.name).app", "\(mountPoint.path)/Applications/Install \(installer.name).app"],
                ["rm", "-r", "/Applications/Install \(installer.name).app"]
            ]
        }

        // workaround for macOS Catalina 10.15 and newer
        if installer.catalinaOrNewer {
            argumentsArrays += [
                ["ditto", "\(mountPoint.path)Applications", "\(mountPoint.path)/Applications"],
                ["rm", "-r", "\(mountPoint.path)Applications"]
            ]
        }

        let variables: [String: String] = ["CM_BUILD": "CM_BUILD"]
        let client: XPCClient = .forMachService(named: .helperIdentifier)

        for arguments in argumentsArrays {
            let request: HelperToolCommandRequest = .init(type: .installer, arguments: arguments, environment: variables)
            let response: HelperToolCommandResponse = try await client.sendMessage(request, to: XPCRoute.commandRoute)

            guard response.terminationStatus == 0 else {
                throw MistError.invalidTerminationStatus(status: response.terminationStatus, output: response.standardOutput, error: response.standardError)
            }
        }
    }
}
