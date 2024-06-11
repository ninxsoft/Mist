//
//  AppIcon.swift
//  Mist
//
//  Created by Nindi Gill on 25/2/2024.
//

import Foundation

enum AppIcon: String, CaseIterable, Identifiable {
    case monterey = "Monterey"
    case ventura = "Ventura"
    case sonoma = "Sonoma"
    case sequoia = "Sequoia"

    static let `default`: AppIcon = .sequoia

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
