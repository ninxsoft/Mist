//
//  FileAttributesUpdater.swift
//  Mist
//
//  Created by Nindi Gill on 8/12/2022.
//

import Foundation
import SecureXPC

/// Helper struct to update file / directory attributes
struct FileAttributesUpdater {

    /// Update file / directory attributes at the provided URL.
    ///
    /// - Parameters:
    ///   - url:              The URL of the file / directory to update.
    ///   - ownerAccountName: The username of the user that will be used to set the file / directory ownership.
    ///
    /// - Throws: An `Error` if the command failed to execute.
    static func update(url: URL, ownerAccountName: String) async throws {

        guard FileManager.default.fileExists(atPath: url.path) else {
            return
        }

        let arguments: [String] = [url.path, ownerAccountName]
        let client: XPCClient = XPCClient.forMachService(named: .helperIdentifier)
        let request: HelperToolCommandRequest = HelperToolCommandRequest(type: .fileAttributes, arguments: arguments, environment: [:])
        let response: HelperToolCommandResponse = try await client.sendMessage(request, to: XPCRoute.commandRoute)

        guard response.terminationStatus == 0 else {
            throw MistError.invalidTerminationStatus(status: response.terminationStatus, output: response.standardOutput, error: response.standardError)
        }
    }
}
