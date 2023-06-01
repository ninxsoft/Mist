//
//  SettingsISOsView.swift
//  Mist
//
//  Created by Nindi Gill on 16/6/2022.
//

import SwiftUI

struct SettingsISOsView: View {
    @AppStorage("isoFilename")
    private var isoFilename: String = .isoFilenameTemplate
    private let imageName: String = "ISO"
    private let title: String = "ISOs"
    // swiftlint:disable:next line_length
    private let description: String = "ISOs are Bootable macOS Installer Disk Images that can be restored on external USB drives, or used with virtualization software (ie. [Parallels Desktop](https://www.parallels.com/au/products/desktop/), [UTM](https://mac.getutm.app), [VMware Fusion](https://www.vmware.com/au/products/fusion.html), [VirtualBox](https://www.virtualbox.org)).\n\n**Note:** ISOs are unavailable for building **macOS Catalina 10.15 and older** on [Apple Silicon Macs](https://support.apple.com/en-us/HT211814)."

    var body: some View {
        VStack(alignment: .leading) {
            SettingsHeaderView(imageName: imageName, title: title, description: description)
            PaddedDivider()
            DynamicTextView(title: "ISO filename: ", text: $isoFilename, placeholder: .isoFilenameTemplate) { text in
                text.stringWithSubstitutions(name: Installer.example.name, version: Installer.example.version, build: Installer.example.build)
            }
            FooterText(Installer.filenameDescription)
            PaddedDivider()
            ResetToDefaultButton {
                reset()
            }
        }
        .padding()
    }

    private func reset() {
        isoFilename = .isoFilenameTemplate
    }
}

struct SettingsISOsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsISOsView()
    }
}
