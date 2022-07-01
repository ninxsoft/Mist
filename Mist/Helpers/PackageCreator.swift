//
//  PackageCreator.swift
//  Mist
//
//  Created by Nindi Gill on 22/6/2022.
//

import Foundation

/// Helper struct to create macOS Installer Packages.
struct PackageCreator {

    /// Create a macOS Installer Package with a custom root directory and scripts.
    ///
    /// - Parameters:
    ///   - url:        The URL of the Package to be created.
    ///   - installer:  The `Installer` struct containing metadata of the macOS Installer.
    ///   - identifier: The package identifier.
    ///   - root:       The URL of the package root directory.
    ///   - scripts:    The URL of the package scripts directory.
    ///   - identity:   Optional Codesigning identity used to sign the package.
    ///
    /// - Throws: An `Error` if the command failed to execute.
    static func create(_ url: URL, from installer: Installer, identifier: String, root: URL, scripts: URL, identity: String? = nil) async throws {
        var arguments: [String] = [
            "pkgbuild",
            "--identifier", identifier,
            "--version", installer.version,
            "--root", root.path,
            "--scripts", scripts.path,
            "--install-location", "\(String.temporaryDirectory)/\(installer.id)"
        ]

        if let identity: String = identity {
            arguments.append(contentsOf: ["--sign", identity])
        }

        arguments.append(url.path)
        try await create(url, with: arguments)
    }

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
        let result: (terminationStatus: Int32, standardOutput: String?, standardError: String?) = try ShellExecutor.shared.execute(arguments)

        guard result.terminationStatus == 0 else {
            throw MistError.invalidTerminationStatus(status: result.terminationStatus, string: result.standardError)
        }
    }
}
