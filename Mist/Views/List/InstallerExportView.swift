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
                    .disabled(exports.count == 1 && exportISO)
                InstallerExportViewItem(exportType: .package, selected: $exportPackage)
                    .disabled(exports.count == 1 && exportPackage)
                Spacer()
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

        if !isoCompatible, exportISO {
            exportISO = false
        }

        if !exportApplication, !exportDiskImage, !exportISO, !exportPackage {
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
