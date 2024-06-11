//
//  PropertyListUpdater.swift
//  Mist
//
//  Created by Nindi Gill on 28/10/2023.
//

import Foundation

/// Helper struct to update a Property List key-pair value.
enum PropertyListUpdater {
    /// Update a key-pair value in a Property List.
    ///
    /// - Parameters:
    ///   - url:   The URL of the property list to be updated.
    ///   - key:   The key in the property list to be updated.
    ///   - value: The value to update within the property list.
    ///
    /// - Throws: An `Error` if the command failed to execute.
    static func update(_ url: URL, key: String, value: AnyHashable) throws {
        let input: String = try String(contentsOf: url, encoding: .utf8)

        guard var data: Data = input.data(using: .utf8) else {
            throw MistError.invalidData
        }

        var format: PropertyListSerialization.PropertyListFormat = .xml

        guard var propertyList: [String: Any] = try PropertyListSerialization.propertyList(from: data, options: [.mutableContainers], format: &format) as? [String: Any] else {
            throw MistError.invalidData
        }

        propertyList[key] = value
        data = try PropertyListSerialization.data(fromPropertyList: propertyList, format: .xml, options: .bitWidth)
        let output: String = .init(decoding: data, as: UTF8.self)
        try output.write(to: url, atomically: true, encoding: .utf8)
    }
}
