//
//  Catalog.swift
//  Mist
//
//  Created by Nindi Gill on 6/12/2022.
//

import Foundation

struct Catalog: Identifiable, Decodable, Equatable {

    enum CodingKeys: String, CodingKey {
        // swiftlint:disable:next redundant_string_enum_value
        case type = "type"
        // swiftlint:disable:next redundant_string_enum_value
        case standard = "standard"
        // swiftlint:disable:next redundant_string_enum_value
        case customerSeed = "customerSeed"
        // swiftlint:disable:next redundant_string_enum_value
        case developerSeed = "developerSeed"
        // swiftlint:disable:next redundant_string_enum_value
        case publicSeed = "publicSeed"
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
