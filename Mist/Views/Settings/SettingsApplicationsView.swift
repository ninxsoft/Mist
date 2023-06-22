//
//  SettingsApplicationsView.swift
//  Mist
//
//  Created by Nindi Gill on 15/6/2022.
//

import Combine
import SwiftUI

struct SettingsApplicationsView: View {
    private static let imageNames: [String] = [
        "Application - macOS Sonoma",
        "Application - macOS Ventura",
        "Application - macOS Monterey",
        "Application - macOS Big Sur",
        "Application - macOS Catalina",
        "Application - macOS Mojave",
        "Application - macOS High Sierra",
        "Application - macOS Sierra",
        "Application - OS X El Capitan",
        "Application - OS X Yosemite",
        "Application - OS X Mavericks",
        "Application - OS X Mountain Lion",
        "Application - Mac OS X Lion"
    ]

    @AppStorage("applicationFilename")
    private var applicationFilename: String = .applicationFilenameTemplate
    @State private var imageName: String = randomImageName()
    private let timer: Publishers.Autoconnect<Timer.TimerPublisher> = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    private let title: String = "Applications"
    // swiftlint:disable:next line_length
    private let description: String = "macOS Installer Applications are app bundles that can be used to install macOS on [Intel-based Macs](https://support.apple.com/en-us/HT201581), and [Apple Silicon Macs](https://support.apple.com/en-us/HT211814) (macOS Big Sur 11 and newer)."

    var body: some View {
        VStack(alignment: .leading) {
            SettingsHeaderView(imageName: imageName, title: title, description: description)
            PaddedDivider()
            DynamicTextView(title: "Application filename:", text: $applicationFilename, placeholder: .applicationFilenameTemplate) { text in
                text.stringWithSubstitutions(name: Installer.example.name, version: Installer.example.version, build: Installer.example.build)
            }
            FooterText(Installer.filenameDescription)
            PaddedDivider()
            ResetToDefaultButton {
                reset()
            }
        }
        .padding()
        .onReceive(timer) { _ in
            withAnimation {
                imageName = SettingsApplicationsView.randomImageName()
            }
        }
    }

    private static func randomImageName() -> String {
        imageNames.randomElement() ?? "Application - macOS"
    }

    private func reset() {
        applicationFilename = .applicationFilenameTemplate
    }
}

struct SettingsApplicationsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsApplicationsView()
    }
}
