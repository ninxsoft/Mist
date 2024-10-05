//
//  FileManager+Extension.swift
//  Mist
//
//  Created by Nindi Gill on 17/6/2022.
//

import Foundation

extension FileManager {
    /// Provides the size of a specified directory, in bytes.
    ///
    /// - Parameters:
    ///   - url: The URL of the directory to query.
    ///
    /// - Throws: An `Error` if the directory size is unable to be determined.
    ///
    /// - Returns: The size of the directory in bytes.
    func sizeOfDirectory(at url: URL) throws -> UInt64 {
        var enumeratorError: Error?

        let urlResourceKeys: Set<URLResourceKey> = [
            .isRegularFileKey,
            .fileAllocatedSizeKey,
            .totalFileAllocatedSizeKey
        ]

        guard
            let enumerator: FileManager.DirectoryEnumerator = enumerator(at: url, includingPropertiesForKeys: Array(urlResourceKeys), options: [], errorHandler: { _, error -> Bool in
                enumeratorError = error
                return false
            }) else {
            return 0
        }

        var size: UInt64 = 0

        for item in enumerator {
            if enumeratorError != nil {
                break
            }

            guard let url: URL = item as? URL else {
                continue
            }

            size += try url.fileSize()
        }

        if let error: Error = enumeratorError {
            throw error
        }

        return size
    }
}
