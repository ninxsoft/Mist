//
//  HelperToolCommandType.swift
//  Mist
//
//  Created by Nindi Gill on 21/6/2022.
//

enum HelperToolCommandType: String, Codable {
    // swiftlint:disable:next redundant_string_enum_value
    case remove = "remove"
    // swiftlint:disable:next redundant_string_enum_value
    case fileAttributes = "fileAttributes"
    // swiftlint:disable:next redundant_string_enum_value
    case installer = "installer"
    // swiftlint:disable:next redundant_string_enum_value
    case createinstallmedia = "createinstallmedia"
    // swiftlint:disable:next redundant_string_enum_value
    case kill = "kill"
}
