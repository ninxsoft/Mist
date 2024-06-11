//
//  Sequence+Extension.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import Foundation
import Yams

extension Sequence where Iterator.Element == [String: Any] {
    func firmwaresCSVString() -> String {
        "Name,Version,Build,Size,URL,Date,Compatible,Signed,Beta\n" + map { $0.firmwareCSVString() }.joined()
    }

    func installersCSVString() -> String {
        "Identifier,Name,Version,Build,Size,Date,Compatible,Beta\n" + map { $0.installerCSVString() }.joined()
    }

    func jsonString() throws -> String {
        let data: Data = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted, .sortedKeys])
        return String(decoding: data, as: UTF8.self)
    }

    func propertyListString() throws -> String {
        let data: Data = try PropertyListSerialization.data(fromPropertyList: self, format: .xml, options: .bitWidth)
        return String(decoding: data, as: UTF8.self)
    }

    func yamlString() throws -> String {
        try Yams.dump(object: self)
    }
}
