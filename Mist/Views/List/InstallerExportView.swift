//
//  InstallerExportView.swift
//  Mist
//
//  Created by Nindi Gill on 17/6/2022.
//

import SwiftUI

struct InstallerExportView: View {
    @AppStorage("exportApplication")
    private var exportApplication: Bool = true
    @AppStorage("exportDiskImage")
    private var exportDiskImage: Bool = false
    @AppStorage("exportISO")
    private var exportISO: Bool = false
    @AppStorage("exportPackage")
    private var exportPackage: Bool = false
    var installer: Installer
    @Binding var exports: [InstallerExportType]
    private var isoCompatible: Bool {
        guard let architecture: Architecture = Hardware.architecture else {
            return false
        }

        return (architecture == .intel && installer.mavericksOrNewer) || (architecture == .appleSilicon && installer.bigSurOrNewer)
    }
    private var compatibilityMessage: String {

        guard let architecture: Architecture = Hardware.architecture else {
            return ""
        }

        switch architecture {
        case .appleSilicon:
            return "**Note:** ISOs are unavailable for building **macOS Catalina 10.15 and older** on [Apple Silicon Macs](https://support.apple.com/en-us/HT211814)."
        case .intel:
            return "**Note:** ISOs are unavailable for building **OS X Mountain Lion 10.8 and older** on Intel-based Macs."
        }
    }

    var body: some View {
        VStack {
            Text("Select Export Types:")
                .padding(.bottom)
            HStack {
                Spacer()
                InstallerExportViewItem(exportType: .application, selected: $exportApplication)
                    .disabled(exports.count == 1 && exportApplication)
                InstallerExportViewItem(exportType: .diskImage, selected: $exportDiskImage)
                    .disabled(exports.count == 1 && exportDiskImage)
                InstallerExportViewItem(exportType: .iso, selected: $exportISO)
                    .disabled(isoCompatible ? exports.count == 1 && exportISO : true)
                    .opacity(isoCompatible ? 1 : 0.5)
                InstallerExportViewItem(exportType: .package, selected: $exportPackage)
                    .disabled(exports.count == 1 && exportPackage)
                Spacer()
            }
            if !isoCompatible {
                Text(.init(compatibilityMessage))
                    .padding(.top)
            }
        }
        .padding()
        .onChange(of: exportApplication) { _ in
            updateExports()
        }
        .onChange(of: exportDiskImage) { _ in
            updateExports()
        }
        .onChange(of: exportISO) { _ in
            updateExports()
        }
        .onChange(of: exportPackage) { _ in
            updateExports()
        }
        .onAppear {
            updateExports()
        }
    }

    private func updateExports() {

        var exports: [InstallerExportType] = []

        if !isoCompatible && exportISO {
            exportISO = false
        }

        if !exportApplication && !exportDiskImage && !exportISO && !exportPackage {
            exportApplication = true
        }

        if exportApplication {
            exports.append(.application)
        }

        if exportDiskImage {
            exports.append(.diskImage)
        }

        if exportISO {
            exports.append(.iso)
        }

        if exportPackage {
            exports.append(.package)
        }

        self.exports = exports
    }
}

struct InstallerExportView_Previews: PreviewProvider {
    static var previews: some View {
        InstallerExportView(installer: .example, exports: .constant(InstallerExportType.allCases))
    }
}
