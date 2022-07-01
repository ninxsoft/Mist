//
//  FileCompressor.swift
//  Mist
//
//  Created by Nindi Gill on 22/6/2022.
//

import Foundation

/// Helper struct to create Zip archives.
struct FileCompressor {

    /// Compress a file or the contents of a directory.
    ///
    /// - Parameters:
    ///   - url:         The URL of the file or directory to be compressed.
    ///   - destination: The URL of the Zip file to be created.
    ///
    /// - Throws: An `Error` if the command failed to execute.
    static func compress(_ url: URL, to destination: URL) async throws {
        try await DirectoryRemover.remove(destination)

        let arguments: [String] = ["ditto", "-c", "-k", "--keepParent", "--sequesterRsrc", "--zlibCompressionLevel", "0", url.path, destination.path]
        let result: (terminationStatus: Int32, standardOutput: String?, standardError: String?) = try ShellExecutor.shared.execute(arguments)

        guard result.terminationStatus == 0 else {
            throw MistError.invalidTerminationStatus(status: result.terminationStatus, string: result.standardError)
        }
    }
}
