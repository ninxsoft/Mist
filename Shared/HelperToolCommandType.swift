//
//  HelperToolCommandType.swift
//  Mist
//
//  Created by Nindi Gill on 21/6/2022.
//

import Foundation

enum HelperToolCommandType: String, Codable {
    // swiftlint:disable redundant_string_enum_value
    case remove = "remove"
    case installer = "installer"
    case createinstallmedia = "createinstallmedia"
    case kill = "kill"
}
