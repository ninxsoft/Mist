//
//  SettingsAboutView.swift
//  Mist
//
//  Created by Nindi Gill on 15/6/2022.
//

import SwiftUI

struct SettingsAboutView: View {
    @Environment(\.openURL)
    var openURL: OpenURLAction
    private var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    private var build: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
    private let length: CGFloat = 128
    private let spacing: CGFloat = 3

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ScaledImage(length: length)
                VStack(alignment: .leading) {
                    Text("Mist")
                        .font(.largeTitle)
                    Text("The macOS Installer Super Tool")
                        .font(.title3)
                    HStack(spacing: spacing) {
                        Text("Version: \(version)")
                        Text("(\(build))")
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
            }
            PaddedDivider()
            HStack {
                Text("Made with 🩸,💧, and whole lot of 😭 by [Ninxsoft](https://github.com/ninxsoft)")
                Spacer()
                Button("Visit Homepage") {
                    visitHomepage()
                }
            }
        }
        .padding()
    }

    private func visitHomepage() {

        guard let url: URL = URL(string: .repositoryURL) else {
            return
        }

        openURL(url)
    }
}

struct SettingsAboutView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsAboutView()
    }
}
