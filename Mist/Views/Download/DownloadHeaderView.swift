//
//  DownloadHeaderView.swift
//  Mist
//
//  Created by Nindi Gill on 28/6/2022.
//

import SwiftUI

struct DownloadHeaderView: View {
    var imageName: String
    var name: String
    var version: String
    var build: String
    private let length: CGFloat = 32

    var body: some View {
        HStack {
            ScaledImage(name: imageName, length: length)
            Text("\(name) \(version) (\(build))")
                .font(.title)
        }
        .padding()
    }
}

struct DownloadHeaderView_Previews: PreviewProvider {
    static let firmware: Firmware = .example
    static let installer: Installer = .example

    static var previews: some View {
        DownloadHeaderView(imageName: firmware.imageName, name: firmware.name, version: firmware.version, build: firmware.build)
        DownloadHeaderView(imageName: installer.imageName, name: installer.name, version: installer.version, build: installer.build)
    }
}
