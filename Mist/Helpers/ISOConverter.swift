//
//  ISOConverter.swift
//  Mist
//
//  Created by Nindi Gill on 22/6/2022.
//

import Foundation

/// Helper struct to convert Disk Images to ISOs.
struct ISOConverter {

    /// Convert a Disk Image to an ISO.
    ///
    /// - Parameters:
    ///   - source:      The URL of the Disk Image to be converted.
    ///   - destination: The URL of the ISO to be created.
    ///
    /// - Throws: An `Error` if the command failed to execute.
    static func convert(_ source: URL, destination: URL) async throws {
        let arguments: [String] = ["hdiutil", "convert", source.path, "-format", "UDTO", "-o", destination.path]
        let result: (terminationStatus: Int32, standardOutput: String?, standardError: String?) = try ShellExecutor.shared.execute(arguments)

        guard result.terminationStatus == 0 else {
            throw MistError.invalidTerminationStatus(status: result.terminationStatus, string: result.standardError)
        }
    }
}
