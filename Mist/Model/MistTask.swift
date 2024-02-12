//
//  MistTask.swift
//  Mist
//
//  Created by Nindi Gill on 17/6/2022.
//

import Foundation

struct MistTask: Identifiable {
    let id: UUID = .init()
    let type: MistTaskType
    var state: MistTaskState = .pending
    let description: String
    var downloadSize: UInt64?
    let operation: @Sendable () async throws -> Void

    var currentDescription: String {
        var prefix: String = type.rawValue
        var suffix: String = description

        switch state {
        case .pending:
            break
        case .inProgress:
            switch type {
            case .configure, .move, .create, .remove:
                prefix = "\(prefix.dropLast(1))ing"
            default:
                prefix = "\(prefix)ing"
            }
            suffix = "\(suffix)..."
        case .complete:
            switch type {
            case .configure, .move, .create, .remove:
                prefix = "\(prefix)d"
            case .download, .codesign, .mount, .unmount, .convert:
                prefix = "\(prefix)ed"
            case .verify, .copy:
                prefix = "\(prefix.dropLast(1))ied"
            }
        case .error:
            switch type {
            case .configure, .move, .create, .remove:
                prefix = "Error \(prefix.dropLast(1).lowercased())ing"
            default:
                prefix = "Error \(prefix.lowercased())ing"
            }
            suffix = "\(suffix)..."
        }

        return "\(prefix) \(suffix)"
    }
}

extension MistTask: Equatable {
    static func == (lhs: MistTask, rhs: MistTask) -> Bool {
        lhs.id == rhs.id
    }
}

extension MistTask: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
