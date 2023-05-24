//
//  SettingsFirmwaresView.swift
//  Mist
//
//  Created by Nindi Gill on 15/6/2022.
//

import SwiftUI

struct SettingsFirmwaresView: View {
    @AppStorage("firmwareFilename")
    private var firmwareFilename: String = .firmwareFilenameTemplate
    private let imageName: String = "Firmware"
    private let title: String = "Firmwares"
    // swiftlint:disable:next line_length
    private let description: String = "macOS Firmwares are **IPSW** files that can be used to restore [Apple Silicon Macs](https://support.apple.com/en-us/HT211814) using [Apple Configurator](https://apps.apple.com/us/app/apple-configurator/id1037126344?mt=12).\n\nmacOS Firmware metadata is provided by the [IPSW Downloads API](https://ipswdownloads.docs.apiary.io/)."

    var body: some View {
        VStack(alignment: .leading) {
            SettingsHeaderView(imageName: imageName, title: title, description: description)
            PaddedDivider()
            DynamicTextView(title: "Firmware filename:", text: $firmwareFilename, placeholder: .firmwareFilenameTemplate) { text in
                text.stringWithSubstitutions(name: Firmware.example.name, version: Firmware.example.version, build: Firmware.example.build)
            }
            FooterText(Firmware.filenameDescription)
            PaddedDivider()
            ResetToDefaultButton {
                reset()
            }
        }
        .padding()
    }

    private func reset() {
        firmwareFilename = .firmwareFilenameTemplate
    }
}

struct SettingsFirmwaresView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsFirmwaresView()
    }
}
