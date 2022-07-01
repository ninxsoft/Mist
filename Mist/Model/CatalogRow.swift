//
//  CatalogRow.swift
//  Mist
//
//  Created by Nindi Gill on 15/6/2022.
//

import Foundation

struct CatalogRow: Identifiable, Hashable {

    static var example: CatalogRow {
        CatalogRow(url: Catalog.standard.url)
    }

    var id: UUID = UUID()
    var url: String
}
