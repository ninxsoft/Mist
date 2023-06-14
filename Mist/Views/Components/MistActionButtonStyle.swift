//
//  MistActionButtonStyle.swift
//  Mist
//
//  Created by Nindi Gill on 5/6/2023.
//

import SwiftUI

struct MistActionButtonStyle: ButtonStyle {
    private let padding: CGFloat = 5

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.bold())
            .padding(.horizontal)
            .padding(.vertical, padding)
            .foregroundColor(.white)
            .background(Color.accentColor.brightness(configuration.isPressed ? -0.5 : 0))
    }
}
