//
//  DiskImageMounter.swift
//  Mist
//
//  Created by Nindi Gill on 21/6/2022.
//

import Foundation

/// Helper struct to mount Disk Images.
struct DiskImageMounter {

    /// Mount a Disk Image at the provided mount point.
    ///
    /// - Parameters:
    ///   - url:        The URL of the disk image to mount.
    ///   - mountPoint: The URL of the directory mount point.
    ///
    /// - Throws: A `MistError` if the command failed to execute.
    static func mount(_ url: URL, mountPoint: URL) async throws {

        do {
            try await DiskImageUnmounter.unmount(mountPoint)
        } catch {
            // do nothing
        }

        let arguments: [String] = ["hdiutil", "attach", url.path, "-noverify", "-mountpoint", mountPoint.path]
        let result: (terminationStatus: Int32, standardOutput: String?, standardError: String?) = try ShellExecutor.shared.execute(arguments)

        guard result.terminationStatus == 0 else {
            throw MistError.invalidTerminationStatus(status: result.terminationStatus, string: result.standardError)
        }
    }
}
