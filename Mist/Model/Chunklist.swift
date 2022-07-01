//
//  Chunklist.swift
//  Mist
//
//  Created by Nindi Gill on 20/6/2022.
//

import Foundation

/// Struct used to store all elements of the Chunklist.
struct Chunklist {

    /// Chunklist Magic Header constant
    static let magicHeader: UInt32 = 0x4C4B4E43
    /// Chunklist Header Size constant
    static let headerSize: UInt32 = 0x00000024
    /// Chunklist File Version constant
    static let fileVersion: UInt8 = 0x01
    /// Chunklist Chunk Method constant
    static let chunkMethod: UInt8 = 0x01
    /// Chunklist Signature Method constant
    static let signatureMethod: UInt8 = 0x02
    /// Chunklist Padding constant
    static let padding: UInt8 = 0x00
    /// Chunklist Chunks Offset constant
    static let chunksOffset: UInt64 = 0x0000000000000024

    /// Magic Header
    let magicHeader: UInt32
    /// Header Size
    let headerSize: UInt32
    /// File Version
    let fileVersion: UInt8
    /// Chunk Method
    let chunkMethod: UInt8
    /// Signature Method
    let signatureMethod: UInt8
    /// Padding
    let padding: UInt8
    /// Total Chunks
    let totalChunks: UInt64
    /// Chunks Offset
    let chunksOffset: UInt64
    /// Signature Offset
    let signatureOffset: UInt64
    /// Chunks Array
    let chunks: [Chunk]
    /// Signature Array
    let signature: [UInt8]

    /// Initializes a chunklist from the provided URL.
    ///
    /// - Parameters:
    ///   - url:  The URL used to retrieve the chunklist.
    ///   - size: The expected file size of the chunklist.
    ///
    /// - Throws: A `MistError` if the Chunklist validation fails
    init(from url: URL, size: Int) throws {

        let data: Data = try Data(contentsOf: url)

        guard data.count == size else {
            throw MistError.chunklistValidationError("Invalid file size: '\(data.count)', should be '\(size)'")
        }

        let array: [UInt8] = [UInt8](data)
        magicHeader = array.uInt32(at: 0x00)
        headerSize = array.uInt32(at: 0x04)
        fileVersion = array.uInt8(at: 0x08)
        chunkMethod = array.uInt8(at: 0x09)
        signatureMethod = array.uInt8(at: 0x0A)
        padding = array.uInt8(at: 0x0B)
        totalChunks = array.uInt64(at: 0x0C)
        chunksOffset = array.uInt64(at: 0x14)
        signatureOffset = array.uInt64(at: 0x1C)
        chunks = Chunklist.chunks(Array(array[Int(chunksOffset)..<Int(signatureOffset)]), totalChunks: Int(totalChunks))
        signature = Array(array[Int(signatureOffset)...])

        guard magicHeader == Chunklist.magicHeader else {
            throw MistError.chunklistValidationError("Invalid magic header: '\(magicHeader.hexString())', should be '\(Chunklist.magicHeader.hexString())'")
        }

        guard headerSize == Chunklist.headerSize else {
            throw MistError.chunklistValidationError("Invalid header size: '\(headerSize.hexString())', should be '\(Chunklist.headerSize.hexString())'")
        }

        guard fileVersion == Chunklist.fileVersion else {
            throw MistError.chunklistValidationError("Invalid file version: '\(fileVersion.hexString())', should be '\(Chunklist.fileVersion.hexString())'")
        }

        guard chunkMethod == Chunklist.chunkMethod else {
            throw MistError.chunklistValidationError("Invalid chunk method: '\(chunkMethod.hexString())', should be '\(Chunklist.chunkMethod.hexString())'")
        }

        guard signatureMethod == Chunklist.signatureMethod else {
            throw MistError.chunklistValidationError("Invalid signature method: '\(signatureMethod.hexString())', should be '\(Chunklist.signatureMethod.hexString())'")
        }

        guard padding == Chunklist.padding else {
            throw MistError.chunklistValidationError("Invalid padding: '\(padding.hexString())', should be '\(Chunklist.padding.hexString())'")
        }

        guard chunksOffset == Chunklist.chunksOffset else {
            throw MistError.chunklistValidationError("Invalid chunks offset: '\(chunksOffset.hexString())', should be '\(Chunklist.chunksOffset.hexString())'")
        }

        guard chunks.count == totalChunks else {
            throw MistError.chunklistValidationError("Incorrect number of chunks: '\(chunks.count)', should be '\(totalChunks)'")
        }

        guard signatureOffset == chunksOffset + totalChunks * 36 else {
            throw MistError.chunklistValidationError("Invalid signature offset: '\(signatureOffset.hexString())', should be '\((chunksOffset + totalChunks * 36).hexString())'")
        }
    }

    /// Returns an array of Chunk structs based on the provided input array.
    ///
    /// - Parameters:
    ///   - array:       An array of `UInt8` values containing the chunk size and hash data.
    ///   - totalChunks: The total number of expected chunks.
    ///
    /// - Returns: An array of Chunk structs.
    private static func chunks(_ array: [UInt8], totalChunks: Int) -> [Chunk] {

        var chunks: [Chunk] = []

        for offset in 0..<totalChunks {
            let size: UInt32 = array.uInt32(at: offset * 0x24)
            let hash: [UInt8] = Array(array[offset * 0x24 + 0x04...(offset * 0x24 + 0x04) + 0x1F])
            let chunk: Chunk = Chunk(size: size, hash: hash)
            chunks.append(chunk)
        }

        return chunks
    }
}
