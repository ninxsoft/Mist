//
//  Chunk.swift
//  Mist
//
//  Created by Nindi Gill on 20/6/2022.
//

import Foundation

/// Struct used to store each chunk's size and hash values.
struct Chunk {
    /// Chunk Size
    let size: UInt32
    /// Chunk Hash Array
    let hash: [UInt8]
    /// Chunk Hash Array represented as a shasum string
    var shasum: String {
        hash.map { $0.hexString() }
            .joined()
            .replacingOccurrences(of: "0x", with: "")
    }
}
