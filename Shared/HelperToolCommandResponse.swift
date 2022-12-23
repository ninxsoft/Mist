//
//  HelperToolCommandResponse.swift
//  Mist
//
//  Created by Nindi Gill on 21/6/2022.
//

struct HelperToolCommandResponse: Codable {
    let terminationStatus: Int32
    let standardOutput: String?
    let standardError: String?
}
