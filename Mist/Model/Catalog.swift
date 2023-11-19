//
//  Catalog.swift
//  Mist
//
//  Created by Nindi Gill on 6/12/2022.
//

import Foundation

struct Catalog: Identifiable, Decodable, Equatable {
    enum CodingKeys: String, CodingKey {
        case type
        case standard
        case customerSeed
        case developerSeed
        case publicSeed
    }

    static var example: Catalog {
        Catalog(type: .ventura, standard: true, customerSeed: false, developerSeed: false, publicSeed: false)
    }

    var id: UUID = UUID()
    var type: CatalogType
    var standard: Bool
    var customerSeed: Bool
    var developerSeed: Bool
    var publicSeed: Bool

    init(type: CatalogType, standard: Bool, customerSeed: Bool, developerSeed: Bool, publicSeed: Bool) {
        self.type = type
        self.standard = standard
        self.customerSeed = customerSeed
        self.developerSeed = developerSeed
        self.publicSeed = publicSeed
    }

    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Catalog.CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(CatalogType.self, forKey: .type)
        standard = try container.decode(Bool.self, forKey: .standard)
        customerSeed = try container.decode(Bool.self, forKey: .customerSeed)
        developerSeed = try container.decode(Bool.self, forKey: .developerSeed)
        publicSeed = try container.decode(Bool.self, forKey: .publicSeed)
    }

    func dictionary() -> [String: Any] {
        [
            "type": type.description,
            "standard": standard,
            "customerSeed": customerSeed,
            "developerSeed": developerSeed,
            "publicSeed": publicSeed
        ]
    }
}
