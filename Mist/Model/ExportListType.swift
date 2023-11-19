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
            return "CSV (Comma Separated Values)"
        case .json:
            return "JSON (JavaScript Object Notation)"
        case .plist:
            return "Plist (Apple Property List)"
        case .yaml:
            return "YAML (YAML Ain't Markup Language)"
        }
    }

    var contentType: UTType {
        switch self {
        case .csv:
            return .commaSeparatedText
        case .json:
            return .json
        case .plist:
            return .propertyList
        case .yaml:
            return .yaml
        }
    }
}
