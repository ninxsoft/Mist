//
//  Dictionary+Extension.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

extension Dictionary where Key == String {

    func firmwareCSVString() -> String {

        guard let signed: Bool = self["signed"] as? Bool,
            let name: String = self["name"] as? String,
            let version: String = self["version"] as? String,
            let build: String = self["build"] as? String,
            let size: UInt64 = self["size"] as? UInt64,
            let date: String = self["date"] as? String,
            let compatible: Bool = self["compatible"] as? Bool else {
            return ""
        }

        let string: String = "\(signed ? "YES" : "NO"),\"\(name)\",\"=\"\"\(version)\"\"\",\"=\"\"\(build)\"\"\",\(size),\(date),\(compatible ? "YES" : "NO")\n"
        return string
    }

    func installerCSVString() -> String {

        guard let identifier: String = self["identifier"] as? String,
            let name: String = self["name"] as? String,
            let version: String = self["version"] as? String,
            let build: String = self["build"] as? String,
            let size: UInt64 = self["size"] as? UInt64,
            let date: String = self["date"] as? String,
            let compatible: Bool = self["compatible"] as? Bool else {
            return ""
        }

        let string: String = "\"\(identifier)\",\"\(name)\",\"=\"\"\(version)\"\"\",\"=\"\"\(build)\"\"\",\(size),\(date),\(compatible ? "YES" : "NO")\n"
        return string
    }
}
