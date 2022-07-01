//
//  URL+Extension.swift
//  Mist
//
//  Created by Nindi Gill on 17/6/2022.
//

import CryptoKit
import Foundation

extension URL {

    func fileSize() throws -> UInt64 {

        let urlResourceKeys: Set<URLResourceKey> = [
            .isRegularFileKey,
            .fileAllocatedSizeKey,
            .totalFileAllocatedSizeKey
        ]

        let resourceValues: URLResourceValues = try self.resourceValues(forKeys: urlResourceKeys)

        guard let isRegularFile: Bool = resourceValues.isRegularFile,
            isRegularFile else {
            return 0
        }

        return UInt64(resourceValues.totalFileAllocatedSize ?? resourceValues.fileAllocatedSize ?? 0)
    }

    func shasum() -> String? {

        let length: Int = 1_024 * 1_024 * 50 // 50 MB

        do {
            let fileHandle: FileHandle = try FileHandle(forReadingFrom: self)

            defer {
                fileHandle.closeFile()
            }

            var shasum: Insecure.SHA1 = Insecure.SHA1()

            while try autoreleasepool(invoking: {
                try Task.checkCancellation()
                let data: Data = fileHandle.readData(ofLength: length)

                if !data.isEmpty {
                    shasum.update(data: data)
                }

                return !data.isEmpty
            }) { }

            let data: Data = Data(shasum.finalize())
            return data.map { String(format: "%02hhx", $0) }.joined()
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
