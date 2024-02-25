//
//  FileMover.swift
//  Mist
//
//  Created by Nindi Gill on 20/6/2022.
//

import Foundation

/// Helper struct to move files.
enum FileMover {
    /// Move a file from one location to another.
    ///
    /// - Parameters:
    ///   - source:      The URL of the file to move.
    ///   - destination: The destination URL.
    ///
    /// - Throws: An `Error` if the command failed to execute.
    static func move(_ source: URL, to destination: URL) async throws {
        try await DirectoryRemover.remove(destination)
        try FileManager.default.moveItem(at: source, to: destination)
    }
}
