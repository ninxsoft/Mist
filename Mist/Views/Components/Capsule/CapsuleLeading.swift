//
//  CapsuleLeading.swift
//  Mist
//
//  Created by Nindi Gill on 10/6/2023.
//

import SwiftUI

struct CapsuleLeading: Shape {

    func path(in rect: CGRect) -> Path {
        var path: Path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.height / 2, y: rect.maxY))
        path.addArc(
            center: CGPoint(x: rect.height / 2, y: rect.midY),
            radius: rect.height / 2,
            startAngle: .degrees(270),
            endAngle: .degrees(90),
            clockwise: true
        )
        path.addLine(to: CGPoint(x: rect.height / 2, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}
