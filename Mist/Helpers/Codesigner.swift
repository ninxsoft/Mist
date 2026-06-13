//
//  Codesigner.swift
//  Mist
//
//  Created by Nindi Gill on 21/6/2022.
//

import Foundation

/// Helper struct to codesign a file (ie. Disk Image).
enum Codesigner {
    /// Sign a file with the provided signing identity.
    ///
    /// - Parameters:
    ///   - url:      The URL of the file to sign.
    ///   - identity: The codesigning identity.
    ///
    /// - Throws: A `MistError` if the command failed to execute.
    static func sign(_ url: URL, identity: String) async throws {
        let arguments: [String] = ["codesign", "--sign", identity, url.path]
        let response: HelperToolCommandResponse = try ShellExecutor.shared.execute(arguments)

        guard response.terminationStatus == 0 else {
            throw MistError.invalidTerminationStatus(status: response.terminationStatus, output: response.standardOutput, error: response.standardError)
        }
    }
    
    /// Sign the provided URL with an ad-hoc code signature.
    ///
    /// - Parameters:
    ///   - url: The URL of the file or directory to sign with an ad-hoc code signature.
    ///
    /// - Throws: A `MistError` if the provided URL is invalid or a command failed to execute.
    static func adHocCodesign(_ url: URL) throws {
        guard
            let enumerator: FileManager.DirectoryEnumerator = FileManager.default.enumerator(
                at: url,
                includingPropertiesForKeys: [.isRegularFileKey],
                options: [.skipsHiddenFiles, .skipsPackageDescendants]
            ) else {
            throw MistError.invalidURL(url.path)
        }
        
        for case let url as URL in enumerator {
            let fileAttributes: URLResourceValues = try url.resourceValues(forKeys: [.isRegularFileKey])
            
            guard
                let isRegularFile: Bool = fileAttributes.isRegularFile,
                isRegularFile else {
                continue
            }
            
            do {
                let arguments: [String] = ["codesign", "--remove-signature", "--force", url.path]
                let response: HelperToolCommandResponse = try ShellExecutor.shared.execute(arguments)
                
                guard response.terminationStatus == 0 else {
                    throw MistError.invalidTerminationStatus(status: response.terminationStatus, output: response.standardOutput, error: response.standardError)
                }
            } catch {
                // do nothing
            }
            
            do {
                let arguments: [String] = ["codesign", "--sign", "-", "--force", url.path]
                let response: HelperToolCommandResponse = try ShellExecutor.shared.execute(arguments)
                
                guard response.terminationStatus == 0 else {
                    throw MistError.invalidTerminationStatus(status: response.terminationStatus, output: response.standardOutput, error: response.standardError)
                }
            } catch {
                // do nothing
            }
        }
    }
}
