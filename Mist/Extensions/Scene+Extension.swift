//
//  Scene+Extension.swift
//  Mist
//
//  Created by Nindi Gill on 1/6/2023.
//

import SwiftUI

extension Scene {
    func fixedWindow() -> some Scene {
        if #available(macOS 13.0, *) {
            self.windowResizability(.contentSize)
        } else {
            self
        }
    }
}
