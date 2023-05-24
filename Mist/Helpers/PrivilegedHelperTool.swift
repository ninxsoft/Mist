//
//  PrivilegedHelperTool.swift
//  Mist
//
//  Created by Nindi Gill on 23/6/2022.
//

import Foundation

/// Helper struct to perform lookups on the Privilged Helper Tool executable.
struct PrivilegedHelperTool {

    /// The URL of the Privileged Helper Tool within the Mist app bundle.
    static let availableURL: URL = URL(fileURLWithPath: "\(Bundle.main.bundlePath)/Contents/Library/LaunchServices/\(String.helperIdentifier)")
    /// The URL of the Privileged Helper Tool within /Library/PrivilegedHelperTools.
    static let installedURL: URL = URL(fileURLWithPath: .helperURL)

    /// Determines if the Privileged Helper Tool is installed correctly.
    ///
    /// - Returns: `true` if the Privileged Helper Tool is installed, otherwise `false`.
    static func isInstalled() -> Bool {

        do {
            // launchctl service is loaded
            let arguments: [String] = ["launchctl", "print", "system/\(String.helperIdentifier)"]
            let response: HelperToolCommandResponse = try ShellExecutor().execute(arguments)

            guard response.terminationStatus == 0 else {
                return false
            }

            // launchdaemon exists
            guard FileManager.default.fileExists(atPath: String.helperLaunchDaemonURL) else {
                return false
            }

            // installed helper tool's launchdaemon matches the one inside the app bundle's helper tool
            let availableLaunchDaemon: HelperToolLaunchdPropertyList = try HelperToolLaunchdPropertyList(from: availableURL)
            let installedLaunchDaemon: HelperToolLaunchdPropertyList = try HelperToolLaunchdPropertyList(from: installedURL)

            guard availableLaunchDaemon == installedLaunchDaemon else {
                return false
            }

            // helper tool exists
            guard FileManager.default.fileExists(atPath: String.helperURL) else {
                return false
            }

            // installed helper tool's info property list matches the one inside the app bundle's helper tool
            let availableInfoPropertyList: HelperToolInfoPropertyList = try HelperToolInfoPropertyList(from: availableURL)
            let installedInfoPropertyList: HelperToolInfoPropertyList = try HelperToolInfoPropertyList(from: installedURL)

            guard availableInfoPropertyList == installedInfoPropertyList else {
                return false
            }

            return true
        } catch {
            return false
        }
    }
}
