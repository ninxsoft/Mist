//
//  PackageCreator.swift
//  Mist
//
//  Created by Nindi Gill on 22/6/2022.
//

import Foundation

/// Helper struct to create macOS Installer Packages.
struct PackageCreator {

    /// Create a macOS Installer Package based off the passed in `Installer` struct.
    ///
    /// - Parameters:
    ///   - url:        The URL of the Package to be created.
    ///   - installer:  The `Installer` struct containing metadata of the macOS Installer.
    ///   - identifier: The package identifier.
    ///   - identity:   Optional Codesigning identity used to sign the package.
    ///
    /// - Throws: An `Error` if the command failed to execute.
    static func create(_ url: URL, from installer: Installer, identifier: String, identity: String? = nil) async throws {

        var arguments: [String] = [
            "pkgbuild",
            "--identifier", identifier,
            "--version", installer.version,
            "--component", installer.temporaryInstallerURL.path,
            "--install-location", "/Applications"
        ]

        if let identity: String = identity {
            arguments.append(contentsOf: ["--sign", identity])
        }

        arguments.append(url.path)
        try await create(url, with: arguments)
    }

    /// Create a macOS Installer Package based in supplied commandline arguments.
    ///
    /// - Parameters:
    ///   - url:       The URL of the package to create.
    ///   - arguments: A list of commandline arguments passed to the shell operation used to create the package.
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
