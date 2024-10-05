//
//  String+Extension.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import Foundation

extension String {
    /// App name
    static let appName: String = "mist"
    /// App identifier
    static let appIdentifier: String = "com.ninxsoft.\(appName)"
    /// Helper identifier
    static let helperIdentifier: String = "\(appIdentifier).helper"
    /// Helper LaunchDaemon URL
    static let helperLaunchDaemonURL: String = "/Library/LaunchDaemons/\(helperIdentifier).plist"
    /// Helper URL
    static let helperURL: String = "/Library/PrivilegedHelperTools/\(helperIdentifier)"
    /// Repository URL
    static let repositoryURL: String = "https://github.com/ninxsoft/Mist"
    /// Filename template
    static let filenameTemplate: String = "Install %NAME% %VERSION%_%BUILD%"
    /// Firmware filename template
    static let firmwareFilenameTemplate: String = "\(filenameTemplate).ipsw"
    /// Application filename template
    static let applicationFilenameTemplate: String = "\(filenameTemplate).app"
    /// Disk Image filename template
    static let diskImageFilenameTemplate: String = "\(filenameTemplate).dmg"
    /// ISO filename template
    static let isoFilenameTemplate: String = "\(filenameTemplate).iso"
    /// Package filename template
    static let packageFilenameTemplate: String = "\(filenameTemplate).pkg"
    /// Package identifier template
    static let packageIdentifierTemplate: String = "com.company.pkg.%NAME%.%VERSION%.%BUILD%"
    /// Tempoarary directory
    static let temporaryDirectory: String = "/private/tmp/\(appIdentifier)"
    /// Cache directory
    static let cacheDirectory: String = "/Users/Shared/Mist/Cache"
    /// TCC database path
    static let tccDatabasePath: String = "/Library/Application Support/com.apple.TCC/TCC.db"
    /// Log URL
    static let logURL: String = "\(appName)://log"

    /// Provides a string replacing placeholder `name`, `version` and `build` values.
    ///
    /// - Parameters:
    ///   - name:    A firmware / installer name.
    ///   - version: A firmware / installer version.
    ///   - build:   A firmware / installer build.
    ///
    /// - Returns: A string with name, version and build placeholders substituted.
    func stringWithSubstitutions(name: String, version: String, build: String) -> String {
        replacingOccurrences(of: "%NAME%", with: name)
            .replacingOccurrences(of: "%VERSION%", with: version)
            .replacingOccurrences(of: "%BUILD%", with: build)
            .replacingOccurrences(of: "//", with: "/")
    }
}
