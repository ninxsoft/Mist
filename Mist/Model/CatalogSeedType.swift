//
//  CatalogSeedType.swift
//  Mist
//
//  Created by Nindi Gill on 8/12/2022.
//

enum CatalogSeedType: String {
    case standard = "Standard"
    case customer = "Customer"
    case developer = "Developer"
    case `public` = "Public"

    var description: String {
        rawValue
    }
}
