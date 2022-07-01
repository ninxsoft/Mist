//
//  Package.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import Foundation

struct Package: Decodable, Hashable {
    enum CodingKeys: String, CodingKey {
        case url = "URL"
        case size = "Size"
        case integrityDataURL = "IntegrityDataURL"
        case integrityDataSize = "IntegrityDataSize"
    }

    let url: String
    let size: Int
    let integrityDataURL: String?
    let integrityDataSize: Int?
    var filename: String {
        url.components(separatedBy: "/").last ?? url
    }
    var dictionary: [String: Any] {
        [
            "url": url,
            "size": size,
            "integrityDataURL": integrityDataURL ?? "",
            "integrityDataSize": integrityDataSize ?? 0
        ]
    }
}
