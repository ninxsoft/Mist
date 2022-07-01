//
//  FileSplitter.swift
//  Mist
//
//  Created by Nindi Gill on 22/6/2022.
//

import Foundation

/// Helper struct to split files into chunks.
struct FileSplitter {

    /// Split a file into chunks with the provided filename prefix.
    ///
    /// - Parameters:
    ///   - url:              The URL of the file to be split.
    ///   - currentDirectory: The directory in which to create the split files.
    ///   - prefix:           The filename prefix for the split files.
    ///
    /// - Throws: An `Error` if the command failed to execute.
    static func split(_ url: URL, from currentDirectory: URL, prefix: String) async throws {
        let fileSize: UInt64 = try url.fileSize()
        let factor: UInt64 = 100
        let chunkSize: UInt64 = 1_024 * 1_024 * factor // 100 MB
        let totalFileChunks: UInt64 = UInt64(ceil(Double(fileSize) / Double(chunkSize)))
        let standardFileChunks: UInt64 = 8_000 / factor // 8000 MB
        let lastFileChunks: UInt64 = totalFileChunks % standardFileChunks
        let numberOfFiles: Int = Int(ceil((Double(totalFileChunks) / Double(standardFileChunks))))
        let readHandle: FileHandle = try FileHandle(forReadingFrom: url)

        for file in 0..<numberOfFiles {
            let isLastFile: Bool = file == numberOfFiles - 1
            let numberOfChunks: UInt64 = isLastFile ? lastFileChunks : standardFileChunks
            let destination: URL = currentDirectory.appendingPathComponent("\(prefix)\(file)")
            try await DirectoryRemover.remove(destination)
            try Data().write(to: destination)
            let writeHandle: FileHandle = try FileHandle(forWritingTo: destination)
            var writeOffset: UInt64 = 0

            for chunk in 0..<numberOfChunks {
                try Task.checkCancellation()
                try autoreleasepool {
                    let readOffset: UInt64 = UInt64(file) * standardFileChunks * chunkSize + UInt64(chunk) * chunkSize
                    try readHandle.seek(toOffset: readOffset)
                    try writeHandle.seek(toOffset: writeOffset)
                    let data: Data = readHandle.readData(ofLength: Int(chunkSize))
                    try writeHandle.write(contentsOf: data)
                    writeOffset += chunkSize
                }
            }

            try writeHandle.close()
        }

        readHandle.closeFile()
    }
}
