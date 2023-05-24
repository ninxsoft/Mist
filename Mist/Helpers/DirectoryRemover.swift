//
//  DirectoryRemover.swift
//  Mist
//
//  Created by Nindi Gill on 21/6/2022.
//

import Foundation
import SecureXPC

/// Helper struct to remove directories
struct DirectoryRemover {

    /// Remove directory at the provided URL.
    ///
    /// - Parameters:
    ///   - url: The URL of the directory to remove.
    ///
    /// - Throws: An `Error` if the command failed to execute.
    static func remove(_ url: URL) async throws {

        guard FileManager.default.fileExists(atPath: url.path) else {
            return
        }

        let arguments: [String] = [url.path]
        let client: XPCClient = XPCClient.forMachService(named: .helperIdentifier)
        let request: HelperToolCommandRequest = HelperToolCommandRequest(type: .remove, arguments: arguments, environment: [:])
        let response: HelperToolCommandResponse = try await client.sendMessage(request, to: XPCRoute.commandRoute)

        guard response.terminationStatus == 0 else {
            throw MistError.invalidTerminationStatus(status: response.terminationStatus, output: response.standardOutput, error: response.standardError)
        }
    }
}
