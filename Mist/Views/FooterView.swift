//
//  FooterView.swift
//  Mist
//
//  Created by Nindi Gill on 28/6/2022.
//

import SwiftUI

struct FooterView: View {
    @Binding var includeBetas: Bool
    @Binding var showCompatible: Bool
    var downloadType: DownloadType
    @Binding var firmwares: [Firmware]
    @Binding var installers: [Installer]
    @State private var savePanel: NSSavePanel = NSSavePanel()
    @State private var exportListType: ExportListType = .json
    private let dateFormatter: DateFormatter = DateFormatter()

    var body: some View {
        HStack {
            Toggle("Include Betas", isOn: $includeBetas)
            Toggle("Only show compatible versions", isOn: $showCompatible)
            Spacer()
            Button("Export List...") {
                export()
            }
        }
        .padding()
        .onChange(of: exportListType) { _ in
            updateSavePanel()
        }
    }

    private func export() {

        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date: String = dateFormatter.string(from: Date())

        savePanel.title = "Export \(downloadType.description) List"
        savePanel.prompt = "Export"
        savePanel.nameFieldStringValue = "Mist \(downloadType.description) \(date)"
        savePanel.canCreateDirectories = true
        savePanel.canSelectHiddenExtension = true
        savePanel.isExtensionHidden = false
        savePanel.allowedContentTypes = [exportListType.contentType]
        savePanel.accessoryView = NSHostingView(rootView: ExportListView(exportListType: $exportListType))

        let response: NSApplication.ModalResponse = savePanel.runModal()

        guard response == .OK,
            let url: URL = savePanel.url else {
            return
        }

        var dictionaries: [[String: Any]]

        switch downloadType {
        case .firmware:
            dictionaries = firmwares.map { $0.dictionary }
        case .installer:
            dictionaries = installers.map { $0.dictionary }
        }

        do {
            switch exportListType {
            case .csv:
                switch downloadType {
                case .firmware:
                    try dictionaries.firmwaresCSVString().write(to: url, atomically: true, encoding: .utf8)
                case .installer:
                    try dictionaries.installersCSVString().write(to: url, atomically: true, encoding: .utf8)
                }
            case .json:
                try dictionaries.jsonString().write(to: url, atomically: true, encoding: .utf8)
            case .plist:
                try dictionaries.propertyListString().write(to: url, atomically: true, encoding: .utf8)
            case .yaml:
                try dictionaries.yamlString().write(to: url, atomically: true, encoding: .utf8)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    private func updateSavePanel() {
        savePanel.allowedContentTypes = [exportListType.contentType]
    }
}

struct FooterView_Previews: PreviewProvider {
    static var previews: some View {
        FooterView(includeBetas: .constant(true), showCompatible: .constant(false), downloadType: .firmware, firmwares: .constant([.example]), installers: .constant([]))
        FooterView(includeBetas: .constant(true), showCompatible: .constant(false), downloadType: .installer, firmwares: .constant([]), installers: .constant([.example]))
    }
}
