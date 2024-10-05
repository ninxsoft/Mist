//
//  Dictionary+Extension.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

extension Dictionary where Key == String {
    /// Provides a firmware CSV string representation.
    ///
    /// - Returns: A firmware CSV string representation.
    func firmwareCSVString() -> String {
        guard
            let name: String = self["name"] as? String,
            let version: String = self["version"] as? String,
            let build: String = self["build"] as? String,
            let size: UInt64 = self["size"] as? UInt64,
            let url: String = self["url"] as? String,
            let date: String = self["date"] as? String,
            let compatible: Bool = self["compatible"] as? Bool,
            let signed: Bool = self["signed"] as? Bool,
            let beta: Bool = self["beta"] as? Bool else {
            return ""
        }

        let nameString: String = "\"\(name)\""
        let versionString: String = "\"=\"\"\(version)\"\"\""
        let buildString: String = "\"=\"\"\(build)\"\"\""
        let sizeString: String = "\(size)"
        let urlString: String = "\"=\"\"\(url)\"\"\""
        let dateString: String = "\(date)"
        let compatibleString: String = "\(compatible ? "YES" : "NO")"
        let signedString: String = "\(signed ? "YES" : "NO")"
        let betaString: String = "\(beta ? "YES" : "NO")"

        let string: String = [
            nameString,
            versionString,
            buildString,
            sizeString,
            urlString,
            dateString,
            compatibleString,
            signedString,
            betaString
        ].joined(separator: ",") + "\n"
        return string
    }

    /// Provides an installer CSV string representation.
    ///
    /// - Returns: An installer CSV string representation.
    func installerCSVString() -> String {
        guard
            let identifier: String = self["identifier"] as? String,
            let name: String = self["name"] as? String,
            let version: String = self["version"] as? String,
            let build: String = self["build"] as? String,
            let size: UInt64 = self["size"] as? UInt64,
            let date: String = self["date"] as? String,
            let compatible: Bool = self["compatible"] as? Bool,
            let beta: Bool = self["beta"] as? Bool else {
            return ""
        }

        let identifierString: String = "\"\(identifier)\""
        let nameString: String = "\"\(name)\""
        let versionString: String = "\"=\"\"\(version)\"\"\""
        let buildString: String = "\"=\"\"\(build)\"\"\""
        let sizeString: String = "\(size)"
        let dateString: String = "\(date)"
        let compatibleString: String = "\(compatible ? "YES" : "NO")"
        let betaString: String = "\(beta ? "YES" : "NO")"

        let string: String = [
            identifierString,
            nameString,
            versionString,
            buildString,
            sizeString,
            dateString,
            compatibleString,
            betaString
        ].joined(separator: ",") + "\n"
        return string
    }
}
