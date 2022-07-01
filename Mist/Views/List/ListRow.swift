//
//  ListRow.swift
//  Mist
//
//  Created by Nindi Gill on 28/6/2022.
//

import Blessed
import SwiftUI

struct ListRow: View {
    var image: String
    var version: String
    var build: String
    var beta: Bool
    var date: String
    var size: String
    var alertMessage: String
    @Binding var showPanel: Bool
    @ObservedObject var taskManager: TaskManager
    @State private var showAlert: Bool = false
    private let length: CGFloat = 48
    private let spacing: CGFloat = 5

    var body: some View {
        HStack {
            ScaledImage(name: image, length: length)
            HStack(spacing: spacing) {
                Text(version)
                    .font(.title2)
                Text("(\(build))")
                    .foregroundColor(.secondary)
            }
            .textSelection(.enabled)
            if beta {
                TextTag(title: "Beta")
            }
            Spacer()
            Text(date)
                .foregroundColor(.secondary)
                .textSelection(.enabled)
            Text(size)
                .textSelection(.enabled)
            Button {
                validate()
            } label: {
                Image(systemName: "arrow.down.circle")
                    .foregroundColor(.accentColor)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Privileged Helper Tool not installed!"),
                message: Text(alertMessage),
                primaryButton: .default(Text("Install...")) { install() },
                secondaryButton: .default(Text("Cancel"))
            )
        }
    }

    private func validate() {

        guard PrivilegedHelperTool.isInstalled() else {
            showAlert = true
            return
        }

        showPanel = true
    }

    private func install() {
        try? PrivilegedHelperManager.shared.authorizeAndBless()
    }
}

struct ListRow_Previews: PreviewProvider {
    static let firmware: Firmware = .example
    static let installer: Installer = .example

    static var previews: some View {
        ListRow(
            image: firmware.imageName,
            version: firmware.version,
            build: firmware.build,
            beta: firmware.beta,
            date: firmware.formattedDate,
            size: firmware.size.bytesString(),
            alertMessage: "Alert Message!",
            showPanel: .constant(false),
            taskManager: .shared
        )
        ListRow(
            image: installer.imageName,
            version: installer.version,
            build: installer.build,
            beta: installer.beta,
            date: installer.date,
            size: installer.size.bytesString(),
            alertMessage: "Alert Message!",
            showPanel: .constant(false),
            taskManager: .shared
        )
    }
}
