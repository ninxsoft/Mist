//
//  InstallerCreator.swift
//  Mist
//
//  Created by Nindi Gill on 21/6/2022.
//

import Foundation
import SecureXPC

/// Helper Struct used to create macOS Installers.
struct InstallerCreator {

    /// Creates a recently downloaded macOS Installer.
    ///
    /// - Parameters:
    ///   - installer:      The selected macOS Installer that was downloaded.
    ///   - mountPoint:     The URL of the directory mount point.
    ///   - cacheDirectory: The cache directory storing all macOS Installer components.
    ///
    /// - Throws: A `MistError` if the downloaded macOS Installer fails to generate.
    static func create(_ installer: Installer, mountPoint: URL, cacheDirectory: String) async throws {

        guard let url: URL = URL(string: installer.distributionURL) else {
            throw MistError.invalidURL(installer.distributionURL)
        }

        try await DirectoryRemover.remove(installer.temporaryInstallerURL)

        let cacheDirectoryURL: URL = URL(fileURLWithPath: cacheDirectory)
        let distributionURL: URL = cacheDirectoryURL.appendingPathComponent(installer.id).appendingPathComponent(url.lastPathComponent)
        var argumentsArrays: [[String]] = [
            ["installer", "-pkg", distributionURL.path, "-target", mountPoint.path]
        ]

        if installer.catalinaOrNewer {
            argumentsArrays += [
                ["ditto", "\(mountPoint.path)Applications", "\(mountPoint.path)/Applications"],
                ["rm", "-r", "\(mountPoint.path)Applications"]
            ]
        }

        let variables: [String: String] = ["CM_BUILD": "CM_BUILD"]
        let client: XPCClient = XPCClient.forMachService(named: .helperIdentifier)

        for arguments in argumentsArrays {
            let request: HelperToolCommandRequest = HelperToolCommandRequest(type: .installer, arguments: arguments, environment: variables)
            let response: HelperToolCommandResponse = try await client.sendMessage(request, to: XPCRoute.commandRoute)

            guard response.terminationStatus == 0 else {
                throw MistError.invalidTerminationStatus(status: response.terminationStatus, string: response.standardError)
            }
        }
    }
}
