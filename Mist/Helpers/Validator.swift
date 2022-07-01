//
//  Validator.swift
//  Mist
//
//  Created by Nindi Gill on 20/6/2022.
//

import CryptoKit
import Foundation

/// Helper struct used to validate Firmware and Installer checksums.
struct Validator {

    /// Validates a Firmware's checksum.
    ///
    /// - Parameters:
    ///   - firmware:    The struct containing Firmware metadata (ie. shasum).
    ///   - destination: The URL of the firmware file to validate.
    ///
    /// - Throws: A `MistError` if the validation fails.
    static func validate(_ firmware: Firmware, at destination: URL) async throws {

        guard let shasum: String = destination.shasum() else {
            throw MistError.invalidData
        }

        guard shasum == firmware.shasum else {
            throw MistError.invalidShasum(invalid: shasum, valid: firmware.shasum)
        }
    }

    /// Validates an Installer package's checksum.
    ///
    /// - Parameters:
    ///   - package:     The struct containing Installer package metadata (ie. chunklist).
    ///   - destination: The URL of the Installer package file to validate.
    ///
    /// - Throws: A `MistError` if the validation fails.
    static func validate(_ package: Package, at destination: URL) async throws {

        guard !package.url.hasSuffix("English.dist") else {
            return
        }

        let attributes: [FileAttributeKey: Any] = try FileManager.default.attributesOfItem(atPath: destination.path)

        guard let fileSize: UInt64 = attributes[.size] as? UInt64 else {
            throw MistError.fileSizeAttributesError(destination)
        }

        guard fileSize == package.size else {
            throw MistError.invalidFileSize(invalid: fileSize, valid: UInt64(package.size))
        }

        guard let string: String = package.integrityDataURL,
            let url: URL = URL(string: string),
            let size: Int = package.integrityDataSize else {
            return
        }

        let chunklist: Chunklist = try Chunklist(from: url, size: size)
        let fileHandle: FileHandle = try FileHandle(forReadingFrom: destination)
        var offset: UInt64 = 0

        for chunk in chunklist.chunks {
            try Task.checkCancellation()
            try autoreleasepool {
                try fileHandle.seek(toOffset: offset)
                let data: Data = fileHandle.readData(ofLength: Int(chunk.size))
                let shasum: String = SHA256.hash(data: data).compactMap { String(format: "%02x", $0) }.joined().uppercased()

                guard shasum == chunk.shasum else {
                    try fileHandle.close()
                    throw MistError.invalidShasum(invalid: shasum, valid: chunk.shasum)
                }

                offset += UInt64(chunk.size)
            }
        }

        try fileHandle.close()
    }
}
