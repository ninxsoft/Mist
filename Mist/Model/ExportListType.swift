//
//  ExportListType.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import UniformTypeIdentifiers

enum ExportListType: String, CaseIterable, Identifiable {
    // swiftlint:disable:next redundant_string_enum_value
    case csv = "csv"
    // swiftlint:disable:next redundant_string_enum_value
    case json = "json"
    // swiftlint:disable:next redundant_string_enum_value
    case plist = "plist"
    // swiftlint:disable:next redundant_string_enum_value
    case yaml = "yaml"

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
