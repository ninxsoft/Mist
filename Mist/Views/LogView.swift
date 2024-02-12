//
//  LogView.swift
//  Mist
//
//  Created by Nindi Gill on 11/2/2024.
//

import SwiftUI

struct LogView: View {
    @AppStorage("logDetailLevel")
    private var detailLevel: LogLevel = .info
    var logEntries: [LogEntry]
    @State private var selectedLogEntries: Set<LogEntry.ID> = []
    @State private var searchString: String = ""
    @State private var savePanel: NSSavePanel = .init()
    private let dateFormatter: DateFormatter = .init()
    private var filteredLogEntries: [LogEntry] {
        let filteredLogEntries: [LogEntry] = switch detailLevel {
        case .info:
            logEntries
        case .warning:
            logEntries.filter { $0.level == .error || $0.level == .warning }
        case .error:
            logEntries.filter { $0.level == .error }
        }

        guard !searchString.isEmpty else {
            return filteredLogEntries
        }

        return filteredLogEntries.filter { $0.message.lowercased().contains(searchString.lowercased()) }
    }

    private let timeColumnWidth: CGFloat = 160
    private let levelColumnWidth: CGFloat = 80
    private let levelCircleRadius: CGFloat = 8
    private let width: CGFloat = 800
    private let height: CGFloat = 600

    var body: some View {
        VStack(spacing: 0) {
            Table(filteredLogEntries, selection: $selectedLogEntries) {
                TableColumn("Timestamp") { logEntry in
                    Text(logEntry.timestamp.ISO8601Format())
                }
                .width(timeColumnWidth)
                TableColumn("Level") { logEntry in
                    HStack {
                        Circle()
                            .fill(logEntry.level.color)
                            .frame(width: levelCircleRadius, height: levelCircleRadius)
                        Text(logEntry.level.description)
                        Spacer()
                    }
                }
                .width(levelColumnWidth)
                TableColumn("Message") { logEntry in
                    Text(logEntry.message)
                        .help(logEntry.message)
                }
            }
            .textSelection(.enabled)
            Divider()
            HStack {
                Spacer()
                Button("Export Log...") {
                    export()
                }
            }
            .padding()
        }
        .frame(minWidth: width, minHeight: height)
        .toolbar {
            Picker("Detail Level", selection: $detailLevel) {
                ForEach(LogLevel.allCases.reversed()) { logLevel in
                    Text(logLevel.detailLevelDescription)
                        .tag(logLevel)
                }
            }
            .help("Detail Level")
        }
        .searchable(text: $searchString)
    }

    private func export() {
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let date: String = dateFormatter.string(from: Date())

        savePanel.title = "Export Mist Log"
        savePanel.prompt = "Export"
        savePanel.nameFieldStringValue = "Mist Log \(date).log"
        savePanel.canCreateDirectories = true
        savePanel.canSelectHiddenExtension = true
        savePanel.isExtensionHidden = false
        savePanel.allowedContentTypes = [.log]

        let response: NSApplication.ModalResponse = savePanel.runModal()

        guard
            response == .OK,
            let url: URL = savePanel.url else {
            return
        }

        do {
            let string: String = logEntries.map(\.description).joined(separator: "\n")
            try string.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView(logEntries: [.example])
    }
}
