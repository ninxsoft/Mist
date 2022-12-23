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
            return "macwindow"
        case .diskImage:
            return "opticaldiscdrive"
        case .iso:
            return "opticaldisc"
        case .package:
            return "shippingbox"
        }
    }
}
