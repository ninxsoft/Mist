//
//  MistTaskState.swift
//  Mist
//
//  Created by Nindi Gill on 17/6/2022.
//

import SwiftUI

enum MistTaskState: String {
    case pending = "Pending"
    case inProgress = "In Progress"
    case complete = "Complete"
    case error = "Error"

    var imageName: String {
        switch self {
        case .pending:
            "hourglass.circle.fill"
        case .inProgress:
            "gear.circle.fill"
        case .complete:
            "checkmark.circle.fill"
        case .error:
            "xmark.circle.fill"
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
        case .error:
            .red
        }
    }
}
