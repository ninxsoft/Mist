//
//  HelperToolInfoPropertyList.swift
//  Mist
//
//  Created by Nindi Gill on 21/6/2022.
//

import EmbeddedPropertyList
import Foundation

struct HelperToolInfoPropertyList: Decodable, Equatable {

    private enum CodingKeys: String, CodingKey {
        case buildHash = "BuildHash"
        case bundleIdentifier = "CFBundleIdentifier"
        case version = "CFBundleVersion"
        case authorizedClients = "SMAuthorizedClients"
    }

    let buildHash: String
    let bundleIdentifier: String
    let version: BundleVersion
    let authorizedClients: [String]

    init() throws {
        let data: Data = try EmbeddedPropertyListReader.info.readInternal()
        self = try PropertyListDecoder().decode(HelperToolInfoPropertyList.self, from: data)
    }

    init(from url: URL) throws {
        let data: Data = try EmbeddedPropertyListReader.info.readExternal(from: url)
        self = try PropertyListDecoder().decode(HelperToolInfoPropertyList.self, from: data)
    }
}
