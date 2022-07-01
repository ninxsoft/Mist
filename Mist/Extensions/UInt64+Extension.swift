//
//  Int64+Extension.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import Foundation

extension UInt64 {

    /// kilobytes constant
    static let kilobyte: UInt64 = 1_000
    /// megabytes constant
    static let megabyte: UInt64 = .kilobyte * 1_000
    /// gigabytes constant
    static let gigabyte: UInt64 = .megabyte * 1_000

    func bytesString() -> String {

        if self < .kilobyte {
            return "\(self) bytes"
        } else if self < .megabyte {
            return String(format: "%5.2f KB", Double(self) / Double(.kilobyte))
        } else if self < .gigabyte {
            return String(format: "%5.2f MB", Double(self) / Double(.megabyte))
        } else {
            return String(format: "%5.2f GB", Double(self) / Double(.gigabyte))
        }
    }

    func hexString() -> String {
        String(format: "0x%016X", self)
    }
}
