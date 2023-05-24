//
//  SettingsPackagesView.swift
//  Mist
//
//  Created by Nindi Gill on 16/6/2022.
//

import SwiftUI

struct SettingsPackagesView: View {
    @AppStorage("packageFilename")
    private var packageFilename: String = .packageFilenameTemplate
    @AppStorage("packageIdentifier")
    private var packageIdentifier: String = .packageIdentifierTemplate
    @AppStorage("packageSign")
    private var packageSign: Bool = false
    @AppStorage("packageSigningIdentity")
    private var packageSigningIdentity: String = ""
    @State private var codesigningIdentities: [String] = ["Loading..."]
    private let packageSignDefault: Bool = false
    private let packageSigningIdentityDefault: String = ""
    private let imageName: String = "Package"
    private let title: String = "Packages"
    private let description: String = "macOS Installer Packages are **PKG** files that can be used to install the macOS Installer Applications into your **Applications** directory."
    // swiftlint:disable:next line_length
    private let codesignDescription: String = "Optionally [codesign](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution) packages to help give users more confidence the contents are coming from a trusted source."

    var body: some View {
        VStack(alignment: .leading) {
            SettingsHeaderView(imageName: imageName, title: title, description: description)
            PaddedDivider()
            Group {
                DynamicTextView(title: "Package filename:", text: $packageFilename, placeholder: .packageFilenameTemplate) { text in
                    text.stringWithSubstitutions(name: Installer.example.name, version: Installer.example.version, build: Installer.example.build)
                }
                FooterText(Installer.filenameDescription)
            }
            PaddedDivider()
            Group {
                DynamicTextView(title: "Package identifier:", text: $packageIdentifier, placeholder: .packageIdentifierTemplate) { text in
                    text.stringWithSubstitutions(name: Installer.example.name, version: Installer.example.version, build: Installer.example.build).replacingOccurrences(of: " ", with: "-")
                }
                FooterText(Installer.packageDescription)
            }
            PaddedDivider()
            Group {
                CodesigningPickerView(enabled: $packageSign, title: "Codesign Packages:", selection: $packageSigningIdentity, identities: codesigningIdentities)
                FooterText(codesignDescription)
            }
            PaddedDivider()
            ResetToDefaultButton {
                reset()
            }
        }
        .padding()
        .onAppear {
            Task {
                updateCodesigningIdentities()
            }
        }
    }

    private func updateCodesigningIdentities() {

        var codesigningIdentities: [String] = []

        let query: [String: Any] = [
            kSecClass: kSecClassIdentity,
            kSecMatchLimit: kSecMatchLimitAll
        ] as [String: Any]
        var items: CFTypeRef?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &items)

        guard status == noErr,
            let identities: [SecIdentity] = items as? [SecIdentity] else {
            self.codesigningIdentities = []
            return
        }

        for identity in identities {
            var certificate: SecCertificate?
            let status: OSStatus = SecIdentityCopyCertificate(identity, &certificate)

            guard status == noErr,
                let certificate: SecCertificate = certificate,
                let subject: String = SecCertificateCopySubjectSummary(certificate) as? String,
                subject.hasPrefix("Developer ID Installer") else {
                continue
            }

            codesigningIdentities.append(subject)
        }

        self.codesigningIdentities = codesigningIdentities
    }

    private func reset() {
        packageFilename = .packageFilenameTemplate
        packageIdentifier = .packageIdentifierTemplate
        packageSign = packageSignDefault
        packageSigningIdentity = packageSigningIdentityDefault
    }
}

struct SettingsPackagesView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPackagesView()
    }
}
