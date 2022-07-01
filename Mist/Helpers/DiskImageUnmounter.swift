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
        let result: (terminationStatus: Int32, standardOutput: String?, standardError: String?) = try ShellExecutor.shared.execute(arguments)

        guard result.terminationStatus == 0 else {
            throw MistError.invalidTerminationStatus(status: result.terminationStatus, string: result.standardError)
        }
    }
}
