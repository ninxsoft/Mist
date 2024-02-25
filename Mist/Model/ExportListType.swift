//
//  ExportListType.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import UniformTypeIdentifiers

enum ExportListType: String, CaseIterable, Identifiable {
    case csv
    case json
    case plist
    case yaml

    var id: String {
        rawValue
    }

    var description: String {
        switch self {
        case .csv:
            "CSV (Comma Separated Values)"
        case .json:
            "JSON (JavaScript Object Notation)"
        case .plist:
            "Plist (Apple Property List)"
        case .yaml:
            "YAML (YAML Ain't Markup Language)"
        }
    }

    var contentType: UTType {
        switch self {
        case .csv:
            .commaSeparatedText
        case .json:
            .json
        case .plist:
            .propertyList
        case .yaml:
            .yaml
        }
    }
}
