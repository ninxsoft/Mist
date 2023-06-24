//
//  ListRowDetail.swift
//  Mist
//
//  Created by Nindi Gill on 12/6/2023.
//

import SwiftUI

struct ListRowDetail: View {
    var imageName: String
    var beta: Bool
    var version: String
    var build: String
    var date: String
    var size: String
    var tooltip: String
    private let length: CGFloat = 48
    private let spacing: CGFloat = 5

    var body: some View {
        HStack {
            ZStack {
                ScaledImage(name: imageName, length: length)
                if beta {
                    TextRibbon(title: "BETA", length: length * 0.9)
                        .textSelection(.disabled)
                }
            }
            HStack(spacing: spacing) {
                Text(version)
                    .font(.title2)
                Text("(\(build))")
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(date)
                .foregroundColor(.secondary)
            Text(size)
        }
        .help(tooltip)
        .textSelection(.enabled)
    }
}

struct ListRowDetail_Previews: PreviewProvider {
    static let firmware: Firmware = .example
    static let installer: Installer = .example

    static var previews: some View {
        ListRowDetail(
            imageName: firmware.imageName,
            beta: firmware.beta,
            version: firmware.version,
            build: firmware.build,
            date: firmware.formattedDate,
            size: firmware.size.bytesString(),
            tooltip: firmware.tooltip
        )
        ListRowDetail(
            imageName: installer.imageName,
            beta: installer.beta,
            version: installer.version,
            build: installer.build,
            date: installer.date,
            size: installer.size.bytesString(),
            tooltip: installer.tooltip
        )
    }
}
