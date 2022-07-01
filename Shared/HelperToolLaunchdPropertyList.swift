//
//  HelperToolLaunchdPropertyList.swift
//  Mist
//
//  Created by Nindi Gill on 21/6/2022.
//

import EmbeddedPropertyList
import Foundation

struct HelperToolLaunchdPropertyList: Decodable, Equatable {

    private enum CodingKeys: String, CodingKey {
        case machServices = "MachServices"
        case label = "Label"
    }

    let machServices: [String: Bool]
    let label: String

    init() throws {
        let data: Data = try EmbeddedPropertyListReader.launchd.readInternal()
        self = try PropertyListDecoder().decode(HelperToolLaunchdPropertyList.self, from: data)
    }

    init(from url: URL) throws {
        let data: Data = try EmbeddedPropertyListReader.launchd.readExternal(from: url)
        self = try PropertyListDecoder().decode(HelperToolLaunchdPropertyList.self, from: data)
    }
}
