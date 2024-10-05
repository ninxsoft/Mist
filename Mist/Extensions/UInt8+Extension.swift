//
//  UInt8+Extension.swift
//  Mist
//
//  Created by Nindi Gill on 20/6/2022.
//

import Foundation

extension UInt8 {
    /// Hexadecimal representation of the 8-bit unsigned integer.
    ///
    /// - Returns: A hexademical string.
    func hexString() -> String {
        String(format: "0x%02X", self)
    }
}
