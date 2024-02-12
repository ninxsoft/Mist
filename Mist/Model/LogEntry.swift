//
//  LogEntry.swift
//  Mist
//
//  Created by Nindi Gill on 11/2/2024.
//

import Foundation

struct LogEntry: Identifiable {
    static var example: LogEntry {
        LogEntry(timestamp: .now, level: .info, message: "Message")
    }

    let id: String = UUID().uuidString
    let timestamp: Date
    let level: LogLevel
    let message: String

    var description: String {
        "\(timestamp.ISO8601Format()) \(level.description) \(message)"
    }
}
