//
//  InstallerVolume.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2023.
//

import Foundation

struct InstallerVolume: Identifiable, Hashable {
    static let placeholder: InstallerVolume = InstallerVolume(id: "placeholder", name: "No volume selected", path: "", capacity: 0)
    static let invalid: InstallerVolume = InstallerVolume(id: "invalid", name: "No available volumes found", path: "", capacity: 0)

    var id: String
    var name: String
    var path: String
    var capacity: UInt64
}
