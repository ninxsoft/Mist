//
//  ProcessKiller.swift
//  Mist
//
//  Created by Nindi Gill on 29/6/2022.
//

import SecureXPC

/// Helper struct to kill the child process of the Privileted Helper Tool.
struct ProcessKiller {

    /// Attempts to kill the child process of the Privileged Helper Tool.
    ///
    /// - Throws: A `MistError` if the process fails to be killed.
    static func kill() async throws {
        let client: XPCClient = XPCClient.forMachService(named: .helperIdentifier)
        let request: HelperToolCommandRequest = HelperToolCommandRequest(type: .kill, arguments: [], environment: [:])
        let response: HelperToolCommandResponse = try await client.sendMessage(request, to: XPCRoute.commandRoute)

        guard response.terminationStatus == 0 else {
            throw MistError.invalidTerminationStatus(status: response.terminationStatus, output: response.standardOutput, error: response.standardError)
        }
    }
}
