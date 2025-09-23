//
//  AppIcon.swift
//  Mist
//
//  Created by Nindi Gill on 25/2/2024.
//

import Foundation

enum AppIcon: String, CaseIterable, Identifiable {
    case monterey = "macOS Monterey"
    case ventura = "macOS Ventura"
    case sonoma = "macOS Sonoma"
    case sequoia = "macOS Sequoia"
    case tahoe = "macOS Tahoe"

    static let `default`: AppIcon = .tahoe

    var id: String {
        rawValue
    }

    var description: String {
        rawValue
    }

    var name: String {
        "App Icon - \(rawValue)"
    }

    var previewName: String {
        "App Icon Preview - \(rawValue)"
    }
}
