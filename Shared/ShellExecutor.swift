//
//  ShellExecutor.swift
//  Mist
//
//  Created by Nindi Gill on 17/6/2022.
//

import Foundation

/// Helper class used to execute shell commands.
class ShellExecutor: NSObject {
    static var shared: ShellExecutor = .init()
    private var process: Process = .init()

    /// Executes custom shell commands.
    ///
    /// - Parameters:
    ///   - arguments:            An array of arguments to execute.
    ///   - variables:            Optionally set custom environment variables.
    ///   - currentDirectoryPath: Optionally set the current directory path
    ///
    /// - Throws: A `MistError` if the exit code is not zero.
    ///
    /// - Returns: The contents of standard output, standard error, and the termination status.
    func execute(
        _ arguments: [String],
        environment variables: [String: String] = [:],
        currentDirectoryPath: String? = nil
    ) throws -> HelperToolCommandResponse {
        let outputPipe: Pipe = .init()
        let errorPipe: Pipe = .init()
        process = Process()
        process.launchPath = "/usr/bin/env"
        process.arguments = arguments
        process.standardOutput = outputPipe
        process.standardError = errorPipe

        var environment: [String: String] = ProcessInfo.processInfo.environment

        for (key, value) in variables {
            environment[key] = value
        }

        process.environment = environment

        if let currentDirectoryPath: String = currentDirectoryPath {
            process.currentDirectoryPath = currentDirectoryPath
        }

        process.launch()
        process.waitUntilExit()

        let outputData: Data = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let standardOutput: String = .init(decoding: outputData, as: UTF8.self)
        let errorData: Data = errorPipe.fileHandleForReading.readDataToEndOfFile()
        let standardError: String = .init(decoding: errorData, as: UTF8.self)
        let terminationStatus: Int32 = process.terminationStatus
        return HelperToolCommandResponse(terminationStatus: terminationStatus, standardOutput: standardOutput, standardError: standardError)
    }

    func terminate() {
        guard process.isRunning else {
            return
        }

        process.terminate()
    }
}
