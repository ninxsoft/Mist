//
//  String+Extension.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import Foundation

extension String {

    static let appName: String = "mist"
    static let appIdentifier: String = "com.ninxsoft.\(appName)"
    static let helperIdentifier: String = "\(appIdentifier).helper"
    static let helperLaunchDaemonURL: String = "/Library/LaunchDaemons/\(helperIdentifier).plist"
    static let helperURL: String = "/Library/PrivilegedHelperTools/\(helperIdentifier)"
    static let repositoryURL: String = "https://github.com/ninxsoft/Mist"
    static let filenameTemplate: String = "Install %NAME% %VERSION%_%BUILD%"
    static let firmwareFilenameTemplate: String = "\(filenameTemplate).ipsw"
    static let applicationFilenameTemplate: String = "\(filenameTemplate).app"
    static let diskImageFilenameTemplate: String = "\(filenameTemplate).dmg"
    static let isoFilenameTemplate: String = "\(filenameTemplate).iso"
    static let packageFilenameTemplate: String = "\(filenameTemplate).pkg"
    static let packageIdentifierTemplate: String = "com.company.pkg.%NAME%.%VERSION%.%BUILD%"
    static let temporaryDirectory: String = "/private/tmp/\(appIdentifier)"
    static let cacheDirectory: String = "/Users/Shared/Mist/Cache"
    static let tccDatabasePath: String = "/Library/Application Support/com.apple.TCC/TCC.db"

    func stringWithSubstitutions(name: String, version: String, build: String) -> String {
        self.replacingOccurrences(of: "%NAME%", with: name)
            .replacingOccurrences(of: "%VERSION%", with: version)
            .replacingOccurrences(of: "%BUILD%", with: build)
            .replacingOccurrences(of: "//", with: "/")
    }
}
