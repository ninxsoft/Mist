//
//  MistTaskSection.swift
//  Mist
//
//  Created by Nindi Gill on 25/6/2022.
//

enum MistTaskSection: String, CaseIterable, Identifiable {
    case download = "Download"
    case setup = "Setup"
    case application = "Application"
    case diskImage = "Disk Image"
    case iso = "ISO"
    case package = "Package"
    case bootableInstaller = "Bootable Installer"
    case cleanup = "Cleanup"

    var id: String {
        rawValue
    }

    var description: String {
        rawValue
    }

    var image: String {
        self == .application ? "Application - macOS" : rawValue
    }
}
