//
//  SettingsDiskImagesView.swift
//  Mist
//
//  Created by Nindi Gill on 16/6/2022.
//

import SwiftUI

struct SettingsDiskImagesView: View {
    @AppStorage("diskImageFilename")
    private var diskImageFilename: String = .diskImageFilenameTemplate
    @AppStorage("diskImageSign")
    private var diskImageSign: Bool = false
    @AppStorage("diskImageSigningIdentity")
    private var diskImageSigningIdentity: String = ""
    @State private var codesigningIdentities: [String] = ["Loading..."]
    private let diskImageSignDefault: Bool = false
    private let diskImageSigningIdentityDefault: String = ""
    private let imageName: String = "Disk Image"
    private let title: String = "Disk Images"
    private let description: String = "macOS Disk Images are **DMG** files that can be used to distribute macOS Installer Applications in an easily transportable format."
    // swiftlint:disable:next line_length
    private let codesignDescription: String = "Optionally [codesign](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution) disk images to help give users more confidence the contents are coming from a trusted source."

    var body: some View {
        VStack(alignment: .leading) {
            SettingsHeaderView(imageName: imageName, title: title, description: description)
            PaddedDivider()
            DynamicTextView(title: "Disk Image filename: ", text: $diskImageFilename, placeholder: .diskImageFilenameTemplate) { text in
                text.stringWithSubstitutions(name: Installer.example.name, version: Installer.example.version, build: Installer.example.build)
            }
            FooterText(Installer.filenameDescription)
            PaddedDivider()
            CodesigningPickerView(enabled: $diskImageSign, title: "Codesign Disk Image:", selection: $diskImageSigningIdentity, identities: codesigningIdentities)
            FooterText(codesignDescription)
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
                subject.hasPrefix("Developer ID Application") else {
                continue
            }

            codesigningIdentities.append(subject)
        }

        self.codesigningIdentities = codesigningIdentities
    }

    private func reset() {
        diskImageFilename = .diskImageFilenameTemplate
        diskImageSign = diskImageSignDefault
        diskImageSigningIdentity = diskImageSigningIdentityDefault
    }
}

struct SettingsDiskImagesView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsDiskImagesView()
    }
}
