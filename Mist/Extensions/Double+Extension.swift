//
//  Double+Extension.swift
//  Mist
//
//  Created by Nindi Gill on 24/6/2022.
//

import Foundation

extension Double {
    /// kilobytes constant
    static let kilobyte: Double = 1_000
    /// megabytes constant
    static let megabyte: Double = .kilobyte * 1_000
    /// gigabytes constant
    static let gigabyte: Double = .megabyte * 1_000

    /// Pretty formatted string representation of the double, as bytes.
    ///
    /// - Returns: A pretty formatted bytes string.
    func bytesString() -> String {
        if self < .kilobyte {
            "\(Int(self)) bytes"
        } else if self < .megabyte {
            String(format: "%5.2f KB", self / .kilobyte)
        } else if self < .gigabyte {
            String(format: "%5.2f MB", self / .megabyte)
        } else {
            String(format: "%5.2f GB", self / .gigabyte)
        }
    }
}
