//
//  DiskImageUnmounter.swift
//  Mist
//
//  Created by Nindi Gill on 21/6/2022.
//

import Foundation

/// Helper struct to unmount Disk Images.
struct DiskImageUnmounter {

    /// Unmount a Disk Image at the provided mount point.
    ///
    /// - Parameters:
    ///   - url: The URL of the directory mount point.
    ///
    /// - Throws: A `MistError` if the command failed to execute.
    static func unmount(_ url: URL) async throws {
        let arguments: [String] = ["hdiutil", "detach", url.path, "-force"]
        let response: HelperToolCommandResponse = try ShellExecutor.shared.execute(arguments)

        guard response.terminationStatus == 0 else {
            throw MistError.invalidTerminationStatus(status: response.terminationStatus, output: response.standardOutput, error: response.standardError)
        }
    }
}
