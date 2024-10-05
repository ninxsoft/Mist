//
//  Sequence+Extension.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import Foundation
import Yams

extension Sequence where Iterator.Element == [String: Any] {
    /// Provides a firmware CSV string representation.
    ///
    /// - Returns: A firmware CSV string representation.
    func firmwaresCSVString() -> String {
        "Name,Version,Build,Size,URL,Date,Compatible,Signed,Beta\n" + map { $0.firmwareCSVString() }.joined()
    }

    /// Provides an installer CSV string representation.
    ///
    /// - Returns: An installer CSV string representation.
    func installersCSVString() -> String {
        "Identifier,Name,Version,Build,Size,Date,Compatible,Beta\n" + map { $0.installerCSVString() }.joined()
    }

    /// Provides a JSON string representation.
    ///
    /// - Throws: An `Error` if a JSON string representation cannot be created.
    ///
    /// - Returns: A JSON string representation.
    func jsonString() throws -> String {
        let data: Data = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted, .sortedKeys])

        guard let string: String = String(data: data, encoding: .utf8) else {
            throw MistError.invalidData
        }

        return string
    }

    /// Provides a Property List string representation.
    ///
    /// - Throws: An `Error` if a Property List string representation cannot be created.
    ///
    /// - Returns: A Property List string representation.
    func propertyListString() throws -> String {
        let data: Data = try PropertyListSerialization.data(fromPropertyList: self, format: .xml, options: .bitWidth)

        guard let string: String = String(data: data, encoding: .utf8) else {
            throw MistError.invalidData
        }

        return string
    }

    /// Provides a YAML string representation.
    ///
    /// - Throws: An `Error` if a YAML string representation cannot be created.
    ///
    /// - Returns: A YAML string representation.
    func yamlString() throws -> String {
        try Yams.dump(object: self)
    }
}
