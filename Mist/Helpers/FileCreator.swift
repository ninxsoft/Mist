//
//  FileCreator.swift
//  Mist
//
//  Created by Nindi Gill on 22/6/2022.
//

import Foundation

/// Helper struct to create files with textual content.
struct FileCreator {

    /// Create a file with the provided string and POSIX permissions.
    ///
    /// - Parameters:
    ///   - url:         The URL of the file to create.
    ///   - contents:    The string to write to disk.
    ///   - permissions: The POSIX permissions to apply to the file being created.
    ///
    /// - Throws: An `Error` if the command failed to execute.
    static func create(_ url: URL, contents: String, permissions: Int) async throws {
        try await DirectoryRemover.remove(url)
        try contents.write(to: url, atomically: true, encoding: .utf8)
        try FileManager.default.setAttributes([.posixPermissions: permissions], ofItemAtPath: url.path)
    }
}
