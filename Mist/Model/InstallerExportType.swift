//
//  InstallerExportType.swift
//  Mist
//
//  Created by Nindi Gill on 17/6/2022.
//

enum InstallerExportType: String, CaseIterable, Identifiable {
    case application = "Application"
    case diskImage = "Disk Image"
    case iso = "ISO"
    case package = "Package"

    var id: String {
        rawValue
    }

    var description: String {
        rawValue
    }

    var systemName: String {
        switch self {
        case .application:
            "macwindow"
        case .diskImage:
            "opticaldiscdrive"
        case .iso:
            "opticaldisc"
        case .package:
            "shippingbox"
        }
    }
}
