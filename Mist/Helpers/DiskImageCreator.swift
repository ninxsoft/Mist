//
//  DiskImageCreator.swift
//  Mist
//
//  Created by Nindi Gill on 21/6/2022.
//

import Foundation

/// Helper struct to create disk images.
struct DiskImageCreator {

    /// Create an empty Disk Image of fixed size.
    ///
    /// - Parameters:
    ///   - url:  The URL of the disk image to create.
    ///   - size: The fixed size of the disk image.
    ///
    /// - Throws: An `MistError` if the command failed to execute.
    static func create(_ url: URL, size: Double) async throws {

        let arguments: [String] = [
            "hdiutil", "create",
            "-fs", "JHFS+",
            "-layout", "SPUD",
            "-size", "\(size)g",
            "-volname", url.lastPathComponent.replacingOccurrences(of: ".dmg", with: ""),
            url.path
        ]
        try await create(url, with: arguments)
    }

    /// Create a Disk Image (with dynamic size) containing the contents of a source directory.
    ///
    /// - Parameters:
    ///   - url:    The URL of the disk image to create.
    ///   - source: The URL of the source directory.
    ///
    /// - Throws: An `MistError` if the command failed to execute.
    static func create(_ url: URL, from source: URL) async throws {

        let arguments: [String] = [
            "hdiutil", "create",
            "-fs", "HFS+",
            "-srcFolder", source.path,
            "-volname", url.lastPathComponent.replacingOccurrences(of: ".dmg", with: ""),
            url.path
        ]
        try await create(url, with: arguments)
    }

    /// Create a Disk Image based in supplied commandline arguments.
    ///
    /// - Parameters:
    ///   - url:       The URL of the disk image to create.
    ///   - arguments: A list of commandline arguments passed to the shell operation used to create the disk image.
    ///
    /// - Throws: An `MistError` if the command failed to execute.
    private static func create(_ url: URL, with arguments: [String]) async throws {

        try await DirectoryRemover.remove(url)
        let response: HelperToolCommandResponse = try ShellExecutor.shared.execute(arguments)

        guard response.terminationStatus == 0 else {
            throw MistError.invalidTerminationStatus(status: response.terminationStatus, output: response.standardOutput, error: response.standardError)
        }
    }
}
