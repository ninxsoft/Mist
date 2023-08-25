//
//  SettingsGeneralHelperView.swift
//  Mist
//
//  Created by Nindi Gill on 21/6/2022.
//

import Authorized
import Blessed
import EmbeddedPropertyList
import SwiftUI

struct SettingsGeneralHelperView: View {
    @State private var availableInfoPropertyList: HelperToolInfoPropertyList?
    @State private var installedInfoPropertyList: HelperToolInfoPropertyList?
    @State private var installed: Bool = false
    @State private var processing: Bool = false
    @State private var showAlert: Bool = false
    @State private var error: Error?
    private let length: CGFloat = 16
    private var status: String {

        guard installed,
            let installed: HelperToolInfoPropertyList = installedInfoPropertyList else {
            return "Not Installed"
        }

        let version: BundleVersion = installed.version
        return "Installed (\(version.major).\(version.minor).\(version.patch))"
    }
    private var errorMessage: String {

        if let error: BlessError = error as? BlessError {
            return error.description
        }

        return error?.localizedDescription ?? ""
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Privileged Helper Tool: \(status)")
                ScaledSystemImage(systemName: installed ? "checkmark.seal.fill" : "xmark.seal.fill", length: length)
                    .foregroundColor(installed ? .green : .red)
                Spacer()
                if processing {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(.small)
                        .padding(.trailing)
                }
                Button("Install...") {
                    install()
                }
                .disabled(installed || processing)
            }
            FooterText("The Mist Privileged Helper Tool is required to perform Administrator tasks when downloading macOS Firmwares and creating macOS Installers.")
        }
        .onAppear {
            verifyInstallationStatus()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("An error has occured!"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func install() {

        processing = true

        do {
            try PrivilegedHelperManager.shared.authorizeAndBless()
            verifyInstallationStatus()
            processing = false
        } catch {
            verifyInstallationStatus()
            processing = false
            self.error = error

            if let error: AuthorizationError = error as? AuthorizationError,
                error == .canceled {
                return
            }

            showAlert = true
        }
    }

    private func verifyInstallationStatus() {
        availableInfoPropertyList = try? HelperToolInfoPropertyList(from: PrivilegedHelperTool.availableURL)
        installedInfoPropertyList = try? HelperToolInfoPropertyList(from: PrivilegedHelperTool.installedURL)
        installed = PrivilegedHelperTool.isInstalled()
    }
}

struct SettingsGeneralHelperView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsGeneralHelperView()
    }
}
