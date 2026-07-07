//
//  CatalogType.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

enum CatalogType: String, CaseIterable, Comparable, Decodable {
    case goldenGate = "macOS Golden Gate"
    case tahoe = "macOS Tahoe"
    case sequoia = "macOS Sequoia"
    case sonoma = "macOS Sonoma"
    case ventura = "macOS Ventura"
    case monterey = "macOS Monterey"
    case bigSur = "macOS Big Sur"

    var description: String {
        rawValue
    }

    var imageName: String {
        rawValue
    }

    private var sortOrder: Int {
        switch self {
        case .goldenGate:
            0
        case .tahoe:
            1
        case .sequoia:
            2
        case .sonoma:
            3
        case .ventura:
            4
        case .monterey:
            5
        case .bigSur:
            6
        }
    }

    static func < (lhs: CatalogType, rhs: CatalogType) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func url(for seedType: CatalogSeedType) -> String {
        switch self {
        case .goldenGate:
            switch seedType {
            case .standard:
                "https://swscan.apple.com/content/catalogs/others/index-27-26-15-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            case .customer:
                // swiftlint:disable:next line_length
                "https://swscan.apple.com/content/catalogs/others/index-27customerseed-27-26-15-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            case .developer:
                // swiftlint:disable:next line_length
                "https://swscan.apple.com/content/catalogs/others/index-27seed-27-26-15-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            case .public:
                // swiftlint:disable:next line_length
                "https://swscan.apple.com/content/catalogs/others/index-27beta-27-26-15-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            }
        case .tahoe:
            switch seedType {
            case .standard:
                "https://swscan.apple.com/content/catalogs/others/index-26-15-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            case .customer:
                // swiftlint:disable:next line_length
                "https://swscan.apple.com/content/catalogs/others/index-26customerseed-26-15-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            case .developer:
                // swiftlint:disable:next line_length
                "https://swscan.apple.com/content/catalogs/others/index-26seed-26-15-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            case .public:
                // swiftlint:disable:next line_length
                "https://swscan.apple.com/content/catalogs/others/index-26beta-26-15-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            }
        case .sequoia:
            switch seedType {
            case .standard:
                "https://swscan.apple.com/content/catalogs/others/index-15-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            case .customer:
                // swiftlint:disable:next line_length
                "https://swscan.apple.com/content/catalogs/others/index-15customerseed-15-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            case .developer:
                "https://swscan.apple.com/content/catalogs/others/index-15seed-15-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            case .public:
                "https://swscan.apple.com/content/catalogs/others/index-15beta-15-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            }
        case .sonoma:
            switch seedType {
            case .standard:
                "https://swscan.apple.com/content/catalogs/others/index-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            case .customer:
                // swiftlint:disable:next line_length
                "https://swscan.apple.com/content/catalogs/others/index-14customerseed-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            case .developer:
                "https://swscan.apple.com/content/catalogs/others/index-14seed-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            case .public:
                "https://swscan.apple.com/content/catalogs/others/index-14beta-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            }
        case .ventura:
            switch seedType {
            case .standard:
                "https://swscan.apple.com/content/catalogs/others/index-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            case .customer:
                "https://swscan.apple.com/content/catalogs/others/index-13customerseed-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            case .developer:
                "https://swscan.apple.com/content/catalogs/others/index-13seed-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            case .public:
                "https://swscan.apple.com/content/catalogs/others/index-13beta-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            }
        case .monterey:
            switch seedType {
            case .standard:
                "https://swscan.apple.com/content/catalogs/others/index-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            case .customer:
                "https://swscan.apple.com/content/catalogs/others/index-12customerseed-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            case .developer:
                "https://swscan.apple.com/content/catalogs/others/index-12seed-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            case .public:
                "https://swscan.apple.com/content/catalogs/others/index-12beta-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            }
        case .bigSur:
            switch seedType {
            case .standard:
                "https://swscan.apple.com/content/catalogs/others/index-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            case .customer:
                "https://swscan.apple.com/content/catalogs/others/index-10.16customerseed-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            case .developer:
                "https://swscan.apple.com/content/catalogs/others/index-10.16seed-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            case .public:
                "https://swscan.apple.com/content/catalogs/others/index-10.16beta-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
            }
        }
    }
}
