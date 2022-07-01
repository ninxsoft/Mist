//
//  Codesigner.swift
//  Mist
//
//  Created by Nindi Gill on 21/6/2022.
//

import Foundation

/// Helper struct to codesign a file (ie. Disk Image).
struct Codesigner {

    /// Sign a file with the provided signing identity.
    ///
    /// - Parameters:
    ///   - url:      The URL of the file to sign.
    ///   - identity: The codesigning identity.
    ///
    /// - Throws: A `MistError` if the command failed to execute.
    static func sign(_ url: URL, identity: String) async throws {
        let arguments: [String] = ["codesign", "--sign", identity, url.path]
        let result: (terminationStatus: Int32, standardOutput: String?, standardError: String?) = try ShellExecutor.shared.execute(arguments)

        guard result.terminationStatus == 0 else {
            throw MistError.invalidTerminationStatus(status: result.terminationStatus, string: result.standardError)
        }
    }
}
