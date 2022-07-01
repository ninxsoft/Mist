//
//  DownloadType.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import Foundation

enum DownloadType: String, CaseIterable, Identifiable {
    case firmware = "Firmware"
    case installer = "Installer"

    var id: String {
        rawValue
    }

    var description: String {
        rawValue
    }
}
