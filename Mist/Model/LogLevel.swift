//
//  LogLevel.swift
//  Mist
//
//  Created by Nindi Gill on 11/2/2024.
//

import Foundation
import SwiftUI

enum LogLevel: String, Identifiable, CaseIterable {
    case info
    case warning
    case error

    var id: String {
        rawValue
    }

    var description: String {
        rawValue.capitalized
    }

    var detailLevelDescription: String {
        switch self {
        case .info:
            "Show all logs"
        case .warning:
            "Show errors and warnings"
        case .error:
            "Show errors only"
        }
    }

    var color: Color {
        switch self {
        case .info:
            .blue
        case .warning:
            .yellow
        case .error:
            .red
        }
    }
}
