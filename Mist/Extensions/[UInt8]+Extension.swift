//
//  [UInt8]+Extension.swift
//  Mist
//
//  Created by Nindi Gill on 20/6/2022.
//

extension [UInt8] {
    /// Provides an 8-bit unsigned integer based of the provided offset in the 8-bit unsigned integer array.
    ///
    /// - Parameters:
    ///   - offset: The offset in the array of unsigned 8-bit integers.
    ///
    /// - Returns: The 8-bit unsigned integer in the array at the provided offset.
    func uInt8(at offset: Int) -> UInt8 {
        self[offset]
    }

    /// Provides a 32-bit unsigned integer based of the provided offset in the 8-bit unsigned integer array.
    ///
    /// - Parameters:
    ///   - offset: The offset in the array of unsigned 8-bit integers.
    ///
    /// - Returns: The 32-bit unsigned integer in the array at the provided offset.
    func uInt32(at offset: Int) -> UInt32 {
        self[offset ... offset + 0x03].reversed().reduce(0) {
            $0 << 0x08 + UInt32($1)
        }
    }

    /// Provides a 64-bit unsigned integer based of the provided offset in the 8-bit unsigned integer array.
    ///
    /// - Parameters:
    ///   - offset: The offset in the array of unsigned 8-bit integers.
    ///
    /// - Returns: The 64-bit unsigned integer in the array at the provided offset.
    func uInt64(at offset: Int) -> UInt64 {
        self[offset ... offset + 0x07].reversed().reduce(0) {
            $0 << 0x08 + UInt64($1)
        }
    }
}
