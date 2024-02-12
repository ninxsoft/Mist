//
//  LogManager.swift
//  Mist
//
//  Created by Nindi Gill on 11/2/2024.
//

import Foundation
import OSLog

/// Helper class used to manage Log Entries and writing out to the unified logging system.
class LogManager: ObservableObject {
    /// Shared instance of a LogManager helper object
    static let shared: LogManager = .init()
    /// Array of Log Entries that have been recorded.
    @Published var logEntries: [LogEntry] = []
    /// Logger object used to send logs.
    private let logger: Logger = .init(subsystem: .appIdentifier, category: "")

    /// Records a log entry and also sends it to the unified logging system.
    ///
    /// - Parameters:
    ///   - level:   The log level of the message.
    ///   - message: The message to log.
    func log(_ level: LogLevel, message: String) {
        DispatchQueue.main.async {
            let entry: LogEntry = .init(timestamp: .now, level: level, message: message)
            self.logEntries.append(entry)

            switch level {
            case .info:
                self.logger.notice("\(message)")
            case .warning:
                self.logger.error("\(message)")
            case .error:
                self.logger.fault("\(message)")
            }
        }
    }
}
