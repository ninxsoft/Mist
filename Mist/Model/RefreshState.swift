//
//  RefreshState.swift
//  Mist
//
//  Created by Nindi Gill on 23/6/2022.
//

import Foundation
import SwiftUI

enum RefreshState: String, CaseIterable, Identifiable {
    case pending = "Pending"
    case inProgress = "In Progress"
    case complete = "Complete"
    case error = "Error"

    var id: String {
        rawValue
    }

    var systemName: String {
        switch self {
        case .pending:
            return "hourglass.circle.fill"
        case .inProgress:
            return "gear.circle.fill"
        case .complete:
            return "checkmark.circle.fill"
        case .error:
            return "x.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .pending:
            return .orange
        case .inProgress:
            return .blue
        case .complete:
            return .green
        case .error:
            return .red
        }
    }
}
