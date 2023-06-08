//
//  DownloadButtonStyle.swift
//  Mist
//
//  Created by Nindi Gill on 5/6/2023.
//

import SwiftUI

struct DownloadButtonStyle: ButtonStyle {

    private let padding: CGFloat = 3

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.bold())
            .padding(.vertical, padding)
            .padding(.horizontal)
            .foregroundColor(.white)
            .background(Color.accentColor.brightness(configuration.isPressed ? -0.5 : 0))
            .clipShape(Capsule())
    }
}
