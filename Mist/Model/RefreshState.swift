//
//  RefreshState.swift
//  Mist
//
//  Created by Nindi Gill on 23/6/2022.
//

import SwiftUI

enum RefreshState: String, CaseIterable, Identifiable {
    case pending = "Pending"
    case inProgress = "In Progress"
    case complete = "Complete"
    case warning = "Warning"
    case error = "Error"

    var id: String {
        rawValue
    }

    var systemName: String {
        switch self {
        case .pending:
            "hourglass.circle.fill"
        case .inProgress:
            "gear.circle.fill"
        case .complete:
            "checkmark.circle.fill"
        case .warning:
            "exclamationmark.triangle.fill"
        case .error:
            "x.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .pending:
            .orange
        case .inProgress:
            .blue
        case .complete:
            .green
        case .warning:
            .yellow
        case .error:
            .red
        }
    }
}
