//
//  Architecture.swift
//  Mist
//
//  Created by Nindi Gill on 1/6/2023.
//

import Foundation

enum Architecture: String {
    case appleSilicon = "arm64"
    case intel = "x86_64"

    var identifier: String {
        rawValue
    }

    var description: String {
        switch self {
        case .appleSilicon:
            return "Apple Silicon"
        case .intel:
            return "Intel-based"
        }
    }
}
