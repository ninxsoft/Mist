//
//  FileManager+Extension.swift
//  Mist
//
//  Created by Nindi Gill on 17/6/2022.
//

import Foundation

extension FileManager {

    func sizeOfDirectory(at url: URL) throws -> UInt64 {

        var enumeratorError: Error?

        let urlResourceKeys: Set<URLResourceKey> = [
            .isRegularFileKey,
            .fileAllocatedSizeKey,
            .totalFileAllocatedSizeKey
        ]

        guard let enumerator: FileManager.DirectoryEnumerator = self.enumerator(at: url, includingPropertiesForKeys: Array(urlResourceKeys), options: [], errorHandler: { _, error -> Bool in
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
