//
//  ButtonStyle+Extension.swift
//  Mist
//
//  Created by Nindi Gill on 5/6/2023.
//

import SwiftUI

extension ButtonStyle where Self == CapsuleButtonStyle {

    static func capsule(_ type: CapsuleButtonStyleType) -> Self {
        .init(type: type)
    }
}
