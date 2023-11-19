//
//  DirectoryCreator.swift
//  Mist
//
//  Created by Nindi Gill on 21/6/2022.
//

import Foundation

/// Helper struct to create directories.
enum DirectoryCreator {
    /// Create a directory at the provided URL.
    ///
    /// - Parameters:
    ///   - url:                         The URL of the directory to create.
    ///   - withIntermediateDirectories: Set to `true` to create all intermediate directories.
    ///
    /// - Throws: An `Error` if the command failed to execute.
    static func create(_ url: URL, withIntermediateDirectories: Bool = false) async throws {
        try await DirectoryRemover.remove(url)
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: withIntermediateDirectories, attributes: nil)
    }
}
