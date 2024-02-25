//
//  FileCopier.swift
//  Mist
//
//  Created by Nindi Gill on 21/6/2022.
//

import Foundation

/// Helper struct to copy files.
enum FileCopier {
    /// Copy a file from one location to another.
    ///
    /// - Parameters:
    ///   - source:      The URL of the file to copy.
    ///   - destination: The destination URL.
    ///
    /// - Throws: An `Error` if the command failed to execute.
    static func copy(_ source: URL, to destination: URL) async throws {
        try await DirectoryRemover.remove(destination)
        try FileManager.default.copyItem(at: source, to: destination)
    }
}
