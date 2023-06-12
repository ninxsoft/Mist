//
//  CapsuleButtonStyle.swift
//  Mist
//
//  Created by Nindi Gill on 5/6/2023.
//

import SwiftUI

struct CapsuleButtonStyle: ButtonStyle {

    let type: CapsuleButtonStyleType
    private let padding: CGFloat = 5

    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {

        let view: some View = configuration.label
            .font(.body.bold())
            .padding(.horizontal)
            .padding(.vertical, padding)
            .foregroundColor(.white)
            .background(Color.accentColor.brightness(configuration.isPressed ? -0.5 : 0))

        switch type {
        case .standard:
            view.clipShape(Capsule())
        case .leading:
            view.clipShape(CapsuleLeading())
        case .trailing:
            view.clipShape(CapsuleTrailing())
        }
    }
}
