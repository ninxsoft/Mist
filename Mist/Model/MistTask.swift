//
//  MistTask.swift
//  Mist
//
//  Created by Nindi Gill on 17/6/2022.
//

import Foundation

struct MistTask: Identifiable {
    let id: UUID = UUID()
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
            prefix = "\(prefix.last == "e" ? String(prefix.dropLast(1)) : prefix)ing"
            suffix = "\(suffix)..."
        case .complete:
            switch type {
            case .download, .codesign, .mount, .unmount, .convert, .compress:
                prefix = "\(prefix)ed"
            case .verify:
                prefix = "Verified"
            case .configure, .save, .create, .remove:
                prefix = "\(prefix)d"
            case .split:
                break
            }
        case .error:
            prefix = "Error \(prefix.last == "e" ? String(prefix.dropLast(1)).lowercased() : prefix)ing"
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
