//
//  ShellExecutor.swift
//  Mist
//
//  Created by Nindi Gill on 17/6/2022.
//

import Foundation

/// Helper class used to execute shell commands.
class ShellExecutor: NSObject {

    static var shared: ShellExecutor = ShellExecutor()
    private var process: Process = Process()

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
        let outputPipe: Pipe = Pipe()
        let errorPipe: Pipe = Pipe()
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
        let standardOutput: String? = String(data: outputData, encoding: .utf8)
        let errorData: Data = errorPipe.fileHandleForReading.readDataToEndOfFile()
        let standardError: String? = String(data: errorData, encoding: .utf8)
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
