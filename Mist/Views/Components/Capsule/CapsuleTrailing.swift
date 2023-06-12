//
//  CapsuleTrailing.swift
//  Mist
//
//  Created by Nindi Gill on 11/6/2023.
//

import SwiftUI

struct CapsuleTrailing: Shape {

    func path(in rect: CGRect) -> Path {
        var path: Path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - rect.height / 2, y: rect.minY))
        path.addArc(
            center: CGPoint(x: rect.maxX - rect.height / 2, y: rect.midY),
            radius: rect.height / 2,
            startAngle: .degrees(90),
            endAngle: .degrees(270),
            clockwise: true
        )
        path.addLine(to: CGPoint(x: rect.maxX - rect.height / 2, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}
