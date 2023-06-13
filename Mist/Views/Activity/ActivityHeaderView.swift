//
//  ActivityHeaderView.swift
//  Mist
//
//  Created by Nindi Gill on 28/6/2022.
//

import SwiftUI

struct ActivityHeaderView: View {
    var imageName: String
    var name: String
    var version: String
    var build: String
    var beta: Bool
    private let length: CGFloat = 48

    var body: some View {
        HStack {
            ZStack {
                ScaledImage(name: imageName, length: length)
                if beta {
                    TextRibbon(title: "BETA", length: length * 0.9)
                }
            }
            Text("\(name) \(version) (\(build))")
                .font(.title)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct ActivityHeaderView_Previews: PreviewProvider {
    static let firmware: Firmware = .example
    static let installer: Installer = .example

    static var previews: some View {
        ActivityHeaderView(imageName: firmware.imageName, name: firmware.name, version: firmware.version, build: firmware.build, beta: false)
        ActivityHeaderView(imageName: installer.imageName, name: installer.name, version: installer.version, build: installer.build, beta: false)
    }
}
