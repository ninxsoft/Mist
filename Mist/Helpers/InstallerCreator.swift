//
//  InstallerCreator.swift
//  Mist
//
//  Created by Nindi Gill on 21/6/2022.
//

import Foundation
import SecureXPC

/// Helper Struct used to create macOS Installers.
enum InstallerCreator {
    /// Creates a recently downloaded macOS Installer.
    ///
    /// - Parameters:
    ///   - installer:      The selected macOS Installer that was downloaded.
    ///   - mountPoint:     The URL of the directory mount point.
    ///   - cacheDirectory: The cache directory storing all macOS Installer components.
    ///
    /// - Throws: A `MistError` if the downloaded macOS Installer fails to generate.
    static func create(_ installer: Installer, mountPoint: URL, cacheDirectory: String) async throws {
        let installerCacheDirectoryURL = URL(fileURLWithPath: cacheDirectory).appendingPathComponent(installer.id)
        let packageURL: URL

        if installer.sierraOrOlder {
            guard let package: Package = installer.packages.first else {
                throw MistError.invalidData
            }

            packageURL = URL(fileURLWithPath: "/Volumes/Install \(installer.name)").appendingPathComponent(package.filename.replacingOccurrences(of: ".dmg", with: ".pkg"))
        } else {
            if installer.containsInstallAssistantPackage {
                packageURL = installerCacheDirectoryURL.appendingPathComponent("InstallAssistant.pkg")
            } else if installer.containsInstallAssistantAutoPackage {
                packageURL = installerCacheDirectoryURL.appendingPathComponent("InstallAssistantAuto.pkg")
            } else {
                guard let url: URL = URL(string: installer.distributionURL) else {
                    throw MistError.invalidURL(installer.distributionURL)
                }

                packageURL = installerCacheDirectoryURL.appendingPathComponent(url.lastPathComponent)
            }
        }

        try await DirectoryRemover.remove(installer.temporaryInstallerURL)

        var argumentsArrays: [[String]] = []
        
        let osVersion = ProcessInfo.processInfo.operatingSystemVersion
        if
            installer.highSierraOrNewer, !installer.bigSurOrNewer,
            (osVersion.majorVersion > 15 || (osVersion.majorVersion == 15 && osVersion.minorVersion >= 6)) {
            // Use special method for macOS >= 15.6
            let installAssistantExpansionDirectory = installerCacheDirectoryURL.appendingPathComponent("InstallAssistantAuto")
            let payloadInstallerApp = installAssistantExpansionDirectory.appendingPathComponent("Payload/Install \(installer.name).app")
            let sharedSupportDirectory = payloadInstallerApp.appendingPathComponent("Contents/SharedSupport")
            argumentsArrays += [
                ["pkgutil", "--expand-full", packageURL.path, installAssistantExpansionDirectory.path],
                ["cp", installerCacheDirectoryURL.appendingPathComponent("AppleDiagnostics.chunklist").path, sharedSupportDirectory.path],
                ["cp", installerCacheDirectoryURL.appendingPathComponent("AppleDiagnostics.dmg").path, sharedSupportDirectory.path],
                ["cp", installerCacheDirectoryURL.appendingPathComponent("BaseSystem.chunklist").path, sharedSupportDirectory.path],
                ["cp", installerCacheDirectoryURL.appendingPathComponent("BaseSystem.dmg").path, sharedSupportDirectory.path],
                ["cp", installerCacheDirectoryURL.appendingPathComponent("InstallESDDmg.pkg").path, sharedSupportDirectory.appendingPathComponent("InstallESD.dmg").path],
                ["ditto", payloadInstallerApp.path, mountPoint.appendingPathComponent("Applications").appendingPathComponent("Install \(installer.name).app").path],
                ["rm", "-r", installAssistantExpansionDirectory.path]
            ]
        } else {
            // Use /usr/sbin/installer for macOS < 15.6
            argumentsArrays += [
                ["installer", "-pkg", packageURL.path, "-target", mountPoint.path]
            ]
            
            // workaround for macOS High Sierra 10.13, macOS Mojave 10.14 and macOS Catalina 10.15
            if installer.highSierraOrNewer, !installer.bigSurOrNewer {
                argumentsArrays += [
                    ["ditto", "/Applications/Install \(installer.name).app", "\(mountPoint.path)/Applications/Install \(installer.name).app"],
                    ["rm", "-r", "/Applications/Install \(installer.name).app"]
                ]
            }

            // workaround for macOS Catalina 10.15 and newer
            if installer.catalinaOrNewer {
                argumentsArrays += [
                    ["ditto", "\(mountPoint.path)Applications", "\(mountPoint.path)/Applications"],
                    ["rm", "-r", "\(mountPoint.path)Applications"]
                ]
            }
        }

        let variables: [String: String] = ["CM_BUILD": "CM_BUILD"]
        let client: XPCClient = .forMachService(named: .helperIdentifier)

        for arguments in argumentsArrays {
            let request: HelperToolCommandRequest = .init(type: .installer, arguments: arguments, environment: variables)
            let response: HelperToolCommandResponse = try await client.sendMessage(request, to: XPCRoute.commandRoute)

            guard response.terminationStatus == 0 else {
                throw MistError.invalidTerminationStatus(status: response.terminationStatus, output: response.standardOutput, error: response.standardError)
            }
        }
    }
}
