//
//  InstallMediaCreator.swift
//  Mist
//
//  Created by Nindi Gill on 22/6/2022.
//

import Foundation
import SecureXPC

/// Helper struct to execute the `createinstallmedia` command found in macOS Install app bundles.
struct InstallMediaCreator {

    /// Create the macOS Install Media at the specified mount point.
    ///
    /// - Parameters:
    ///   - url:           The URL of the `createinstallmedia` binary to execute.
    ///   - mountPoint:    The URL of the mount point (target volume).
    ///   - sierraOrOlder: `true` if the installer is macOS Sierra or older, otherwise `false`.
    ///
    /// - Throws: An `Error` if the command failed to execute.
    static func create(_ url: URL, mountPoint: URL, sierraOrOlder: Bool) async throws {
        var arguments: [String] = [url.path, "--volume", mountPoint.path, "--nointeraction"]

        if sierraOrOlder {
            let applicationPath: String = url.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().path
            arguments += ["--applicationpath", applicationPath]
        }

        let client: XPCClient = XPCClient.forMachService(named: .helperIdentifier)
        let request: HelperToolCommandRequest = HelperToolCommandRequest(type: .createinstallmedia, arguments: arguments, environment: [:])
        let response: HelperToolCommandResponse = try await client.sendMessage(request, to: XPCRoute.commandRoute)

        guard response.terminationStatus == 0 else {
            throw MistError.invalidTerminationStatus(status: response.terminationStatus, output: response.standardOutput, error: response.standardError)
        }
    }
}
