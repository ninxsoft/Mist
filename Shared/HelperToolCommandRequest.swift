//
//  HelperToolCommandRequest.swift
//  Mist
//
//  Created by Nindi Gill on 21/6/2022.
//

import Foundation

struct HelperToolCommandRequest: Codable {
    let type: HelperToolCommandType
    let arguments: [String]
    let environment: [String: String]
}
