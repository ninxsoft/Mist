//
//  Codesigner.swift
//  Mist
//
//  Created by Nindi Gill on 21/6/2022.
//

import Foundation

/// Helper struct to codesign a file (ie. Disk Image).
enum Codesigner {
    /// Sign a file with the provided signing identity.
    ///
    /// - Parameters:
    ///   - url:      The URL of the file to sign.
    ///   - identity: The codesigning identity.
    ///
    /// - Throws: A `MistError` if the command failed to execute.
    static func sign(_ url: URL, identity: String) async throws {
        let arguments: [String] = ["codesign", "--sign", identity, url.path]
        let response: HelperToolCommandResponse = try ShellExecutor.shared.execute(arguments)

        guard response.terminationStatus == 0 else {
            throw MistError.invalidTerminationStatus(status: response.terminationStatus, output: response.standardOutput, error: response.standardError)
        }
    }

    /// Ad-hoc sign all files within a directory (or app bundle).
    ///
    /// - Parameters:
    ///   - url: The URL of the directory to ad-hoc sign.
    ///
    /// - Throws: A `MistError` if the command failed to execute.
    static func adhocSign(_ url: URL) async throws {
        let arguments: [String] = ["find", url.path, "-type", "f", "-exec", "codesign", "--sign", "-", "--force", "{}", ";"]
        let response: HelperToolCommandResponse = try ShellExecutor.shared.execute(arguments)

        guard response.terminationStatus == 0 else {
            throw MistError.invalidTerminationStatus(status: response.terminationStatus, output: response.standardOutput, error: response.standardError)
        }
    }
}
