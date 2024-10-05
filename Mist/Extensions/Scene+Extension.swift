//
//  Scene+Extension.swift
//  Mist
//
//  Created by Nindi Gill on 1/6/2023.
//

import SwiftUI

extension Scene {
    /// Fixes the window size across all macOS versions.
    ///
    /// - Returns: A modified window for macOS 13.0 Ventura and later otherwise an unmodified window.
    func fixedWindow() -> some Scene {
        if #available(macOS 13.0, *) {
            // swiftformat:disable:next redundantReturn
            return self.windowResizability(.contentSize)
        } else {
            // swiftformat:disable:next redundantReturn
            return self
        }
    }
}
