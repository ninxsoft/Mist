//
//  Installer.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import Foundation

// swiftlint:disable file_length
// swiftlint:disable:next type_body_length
struct Installer: Decodable, Hashable, Identifiable {

    enum CodingKeys: String, CodingKey {
        case id = "Identifier"
        case version = "Version"
        case build = "Build"
        case date = "PostDate"
        case distributionURL = "DistributionURL"
        case distributionSize = "DistributionSize"
        case packages = "Packages"
        case boardIDs = "BoardIDs"
        case deviceIDs = "DeviceIDs"
        case unsupportedModelIdentifiers = "UnsupportedModelIdentifiers"
    }

    static var example: Installer {
        Installer(
            id: "012-92138",
            version: "13.0",
            build: "22A380",
            date: "2022-10-25",
            distributionURL: "https://swdist.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/012-92138.English.dist",
            distributionSize: 7_467,
            packages: [
                Package(
                    url: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/MajorOSInfo.pkg",
                    size: 1_334_737,
                    integrityDataURL: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/MajorOSInfo.pkg.integrityDataV1",
                    integrityDataSize: 104
                ),
                Package(
                    url: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/InstallAssistant.pkg",
                    size: 12_151_608_300,
                    integrityDataURL: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/InstallAssistant.pkg.integrityDataV1",
                    integrityDataSize: 41_792
                ),
                Package(
                    url: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/BuildManifest.plist",
                    size: 3_355_762,
                    integrityDataURL: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/BuildManifest.plist.integrityDataV1",
                    integrityDataSize: 104
                ),
                Package(
                    url: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/InstallInfo.plist",
                    size: 181,
                    integrityDataURL: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/InstallInfo.plist.integrityDataV1",
                    integrityDataSize: 104
                ),
                Package(
                    url: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/UpdateBrain.zip",
                    size: 3_450_528,
                    integrityDataURL: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/UpdateBrain.zip.integrityDataV1",
                    integrityDataSize: 104
                ),
                Package(
                    url: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/Info.plist",
                    size: 5_042,
                    integrityDataURL: "https://swcdn.apple.com/content/downloads/25/16/012-92138-A_KGGGN26YQB/d0kr042ixfvkboeft8qt2i3aclr5bx1e6p/Info.plist.integrityDataV1",
                    integrityDataSize: 104
                )
            ],
            boardIDs: [
                "Mac-0CFF9C7C2B63DF8D",
                "Mac-112818653D3AABFC",
                "Mac-1E7E29AD0135F9BC",
                "Mac-226CB3C6A851A671",
                "Mac-27AD2F918AE68F61",
                "Mac-4B682C642B45593E",
                "Mac-53FDB3D8DB8CA971",
                "Mac-551B86E5744E2388",
                "Mac-5F9802EFE386AA28",
                "Mac-63001698E7A34814",
                "Mac-77F17D7DA9285301",
                "Mac-7BA5B2D9E42DDD94",
                "Mac-7BA5B2DFE22DDD8C",
                "Mac-827FAC58A8FDFA22",
                "Mac-827FB448E656EC26",
                "Mac-937A206F2EE63C01",
                "Mac-A61BADE1FDAD7B05",
                "Mac-AA95B1DDAB278B95",
                "Mac-AF89B6D9451A490B",
                "Mac-B4831CEBD52A0C4C",
                "Mac-BE088AF8C5EB4FA2",
                "Mac-CAD6701F7CEA0921",
                "Mac-CFF7D910A743CAAF",
                "Mac-E1008331FDC96864",
                "Mac-E7203C0F68AA0004",
                "Mac-EE2EBD4B90B839A8"
            ],
            deviceIDs: [
                "J132AP",
                "J137AP",
                "J140AAP",
                "J140KAP",
                "J152FAP",
                "J160AP",
                "J174AP",
                "J185AP",
                "J185FAP",
                "J213AP",
                "J214AP",
                "J214KAP",
                "J215AP",
                "J223AP",
                "J230AP",
                "J230KAP",
                "J274AP",
                "J293AP",
                "J313AP",
                "J314CAP",
                "J314SAP",
                "J316CAP",
                "J316SAP",
                "J375CAP",
                "J375DAP",
                "J413AP",
                "J456AP",
                "J457AP",
                "J493AP",
                "J680AP",
                "J780AP",
                "VMA2MACOSAP",
                "VMM-X86_64",
                "X589AMLUAP",
                "X86LEGACYAP"
            ],
            unsupportedModelIdentifiers: []
        )
    }

    static var legacyInstallers: [Installer] {
        [
            Installer(
                id: "10.12.6-16G29",
                version: "10.12.6",
                build: "16G29",
                date: "2017-07-15",
                distributionURL: "",
                distributionSize: 0,
                packages: [
                    Package(
                        url: "https://updates.cdn-apple.com/2019/cert/061-39476-20191023-48f365f4-0015-4c41-9f44-39d3d2aca067/InstallOS.dmg",
                        size: 5_007_882_126,
                        integrityDataURL: nil,
                        integrityDataSize: nil
                    )
                ],
                boardIDs: [
                    "Mac-00BE6ED71E35EB86",
                    "Mac-031AEE4D24BFF0B1",
                    "Mac-031B6874CF7F642A",
                    "Mac-06F11F11946D27C5",
                    "Mac-06F11FD93F0323C5",
                    "Mac-189A3D4F975D5FFC",
                    "Mac-27ADBB7B4CEE8E61",
                    "Mac-2BD1B31983FE1663",
                    "Mac-2E6FAB96566FE58C",
                    "Mac-35C1E88140C3E6CF",
                    "Mac-35C5E08120C7EEAF",
                    "Mac-3CBD00234E554E41",
                    "Mac-42FD25EABCABB274",
                    "Mac-473D31EABEB93F9B",
                    "Mac-4B682C642B45593E",
                    "Mac-4B7AC7E43945597E",
                    "Mac-4BC72D62AD45599E",
                    "Mac-50619A408DB004DA",
                    "Mac-551B86E5744E2388",
                    "Mac-65CE76090165799A",
                    "Mac-66E35819EE2D0D05",
                    "Mac-66F35F19FE2A0D05",
                    "Mac-6F01561E16C75D06",
                    "Mac-742912EFDBEE19B3",
                    "Mac-77EB7D7DAF985301",
                    "Mac-77F17D7DA9285301",
                    "Mac-7BA5B2794B2CDB12",
                    "Mac-7DF21CB3ED6977E5",
                    "Mac-7DF2A3B5E5D671ED",
                    "Mac-81E3E92DD6088272",
                    "Mac-8ED6AF5B48C039E1",
                    "Mac-937CB26E2E02BB01",
                    "Mac-942452F5819B1C1B",
                    "Mac-942459F5819B171B",
                    "Mac-94245A3940C91C80",
                    "Mac-94245B3640C91C81",
                    "Mac-942B59F58194171B",
                    "Mac-942B5BF58194151B",
                    "Mac-942C5DF58193131B",
                    "Mac-9AE82516C7C6B903",
                    "Mac-9F18E312C5C2BF0B",
                    "Mac-A369DDC4E67F1C45",
                    "Mac-A5C67F76ED83108C",
                    "Mac-AFD8A9D944EA4843",
                    "Mac-B4831CEBD52A0C4C",
                    "Mac-B809C3757DA9BB8D",
                    "Mac-BE088AF8C5EB4FA2",
                    "Mac-BE0E8AC46FE800CC",
                    "Mac-C08A6BB70A942AC2",
                    "Mac-C3EC7CD22292981F",
                    "Mac-CAD6701F7CEA0921",
                    "Mac-DB15BD556843C820",
                    "Mac-E43C1C25D4880AD6",
                    "Mac-EE2EBD4B90B839A8",
                    "Mac-F305150B0C7DEEEF",
                    "Mac-F60DEB81FF30ACF6",
                    "Mac-F65AE981FFA204ED",
                    "Mac-FA842E06C61E91C5",
                    "Mac-FC02E91DDD3FA6A4",
                    "Mac-FFE5EF870D7BA81A",
                    "Mac-F2208EC8",
                    "Mac-F221BEC8",
                    "Mac-F221DCC8",
                    "Mac-F222BEC8",
                    "Mac-F2238AC8",
                    "Mac-F2238BAE",
                    "Mac-F22586C8",
                    "Mac-F22589C8",
                    "Mac-F2268CC8",
                    "Mac-F2268DAE",
                    "Mac-F2268DC8",
                    "Mac-F22C89C8",
                    "Mac-F22C8AC8"
                ],
                deviceIDs: [],
                unsupportedModelIdentifiers: []
            ),
            Installer(
                id: "10.11.6-15G31",
                version: "10.11.6",
                build: "15G31",
                date: "2016-05-18",
                distributionURL: "",
                distributionSize: 0,
                packages: [
                    Package(
                        url: "https://updates.cdn-apple.com/2019/cert/061-41424-20191024-218af9ec-cf50-4516-9011-228c78eda3d2/InstallMacOSX.dmg",
                        size: 6_204_629_298,
                        integrityDataURL: nil,
                        integrityDataSize: nil
                    )
                ],
                boardIDs: [
                    "Mac-00BE6ED71E35EB86",
                    "Mac-031AEE4D24BFF0B1",
                    "Mac-031B6874CF7F642A",
                    "Mac-06F11F11946D27C5",
                    "Mac-06F11FD93F0323C5",
                    "Mac-189A3D4F975D5FFC",
                    "Mac-27ADBB7B4CEE8E61",
                    "Mac-2BD1B31983FE1663",
                    "Mac-2E6FAB96566FE58C",
                    "Mac-35C1E88140C3E6CF",
                    "Mac-35C5E08120C7EEAF",
                    "Mac-3CBD00234E554E41",
                    "Mac-42FD25EABCABB274",
                    "Mac-4B7AC7E43945597E",
                    "Mac-4BC72D62AD45599E",
                    "Mac-50619A408DB004DA",
                    "Mac-65CE76090165799A",
                    "Mac-66F35F19FE2A0D05",
                    "Mac-6F01561E16C75D06",
                    "Mac-742912EFDBEE19B3",
                    "Mac-77EB7D7DAF985301",
                    "Mac-7BA5B2794B2CDB12",
                    "Mac-7DF21CB3ED6977E5",
                    "Mac-7DF2A3B5E5D671ED",
                    "Mac-81E3E92DD6088272",
                    "Mac-8ED6AF5B48C039E1",
                    "Mac-937CB26E2E02BB01",
                    "Mac-942452F5819B1C1B",
                    "Mac-942459F5819B171B",
                    "Mac-94245A3940C91C80",
                    "Mac-94245B3640C91C81",
                    "Mac-942B59F58194171B",
                    "Mac-942B5BF58194151B",
                    "Mac-942C5DF58193131B",
                    "Mac-9AE82516C7C6B903",
                    "Mac-9F18E312C5C2BF0B",
                    "Mac-A369DDC4E67F1C45",
                    "Mac-AFD8A9D944EA4843",
                    "Mac-B809C3757DA9BB8D",
                    "Mac-BE0E8AC46FE800CC",
                    "Mac-C08A6BB70A942AC2",
                    "Mac-C3EC7CD22292981F",
                    "Mac-DB15BD556843C820",
                    "Mac-E43C1C25D4880AD6",
                    "Mac-F305150B0C7DEEEF",
                    "Mac-F60DEB81FF30ACF6",
                    "Mac-F65AE981FFA204ED",
                    "Mac-FA842E06C61E91C5",
                    "Mac-FC02E91DDD3FA6A4",
                    "Mac-FFE5EF870D7BA81A",
                    "Mac-F2208EC8",
                    "Mac-F2218EA9",
                    "Mac-F2218EC8",
                    "Mac-F2218FA9",
                    "Mac-F2218FC8",
                    "Mac-F221BEC8",
                    "Mac-F221DCC8",
                    "Mac-F222BEC8",
                    "Mac-F2238AC8",
                    "Mac-F2238BAE",
                    "Mac-F223BEC8",
                    "Mac-F22586C8",
                    "Mac-F22587A1",
                    "Mac-F22587C8",
                    "Mac-F22589C8",
                    "Mac-F2268AC8",
                    "Mac-F2268CC8",
                    "Mac-F2268DAE",
                    "Mac-F2268DC8",
                    "Mac-F2268EC8",
                    "Mac-F226BEC8",
                    "Mac-F22788AA",
                    "Mac-F227BEC8",
                    "Mac-F22C86C8",
                    "Mac-F22C89C8",
                    "Mac-F22C8AC8",
                    "Mac-F42386C8",
                    "Mac-F42388C8",
                    "Mac-F4238BC8",
                    "Mac-F4238CC8",
                    "Mac-F42C86C8",
                    "Mac-F42C88C8",
                    "Mac-F42C89C8",
                    "Mac-F42D86A9",
                    "Mac-F42D86C8",
                    "Mac-F42D88C8",
                    "Mac-F42D89A9",
                    "Mac-F42D89C8"
                ],
                deviceIDs: [],
                unsupportedModelIdentifiers: []
            ),
            Installer(
                id: "10.10.5-14F27",
                version: "10.10.5",
                build: "14F27",
                date: "2015-08-05",
                distributionURL: "",
                distributionSize: 0,
                packages: [
                    Package(
                        url: "https://updates.cdn-apple.com/2019/cert/061-41343-20191023-02465f92-3ab5-4c92-bfe2-b725447a070d/InstallMacOSX.dmg",
                        size: 5_718_074_248,
                        integrityDataURL: nil,
                        integrityDataSize: nil
                    )
                ],
                boardIDs: [
                    "Mac-00BE6ED71E35EB86",
                    "Mac-031AEE4D24BFF0B1",
                    "Mac-031B6874CF7F642A",
                    "Mac-06F11F11946D27C5",
                    "Mac-06F11FD93F0323C5",
                    "Mac-189A3D4F975D5FFC",
                    "Mac-27ADBB7B4CEE8E61",
                    "Mac-2BD1B31983FE1663",
                    "Mac-2E6FAB96566FE58C",
                    "Mac-35C1E88140C3E6CF",
                    "Mac-35C5E08120C7EEAF",
                    "Mac-3CBD00234E554E41",
                    "Mac-42FD25EABCABB274",
                    "Mac-4B7AC7E43945597E",
                    "Mac-4BC72D62AD45599E",
                    "Mac-50619A408DB004DA",
                    "Mac-66F35F19FE2A0D05",
                    "Mac-6F01561E16C75D06",
                    "Mac-742912EFDBEE19B3",
                    "Mac-77EB7D7DAF985301",
                    "Mac-7BA5B2794B2CDB12",
                    "Mac-7DF21CB3ED6977E5",
                    "Mac-7DF2A3B5E5D671ED",
                    "Mac-81E3E92DD6088272",
                    "Mac-8ED6AF5B48C039E1",
                    "Mac-937CB26E2E02BB01",
                    "Mac-942452F5819B1C1B",
                    "Mac-942459F5819B171B",
                    "Mac-94245A3940C91C80",
                    "Mac-94245B3640C91C81",
                    "Mac-942B59F58194171B",
                    "Mac-942B5BF58194151B",
                    "Mac-942C5DF58193131B",
                    "Mac-9F18E312C5C2BF0B",
                    "Mac-AFD8A9D944EA4843",
                    "Mac-BE0E8AC46FE800CC",
                    "Mac-C08A6BB70A942AC2",
                    "Mac-C3EC7CD22292981F",
                    "Mac-E43C1C25D4880AD6",
                    "Mac-F305150B0C7DEEEF",
                    "Mac-F60DEB81FF30ACF6",
                    "Mac-F65AE981FFA204ED",
                    "Mac-FA842E06C61E91C5",
                    "Mac-FC02E91DDD3FA6A4",
                    "Mac-F2208EC8",
                    "Mac-F2218EA9",
                    "Mac-F2218EC8",
                    "Mac-F2218FA9",
                    "Mac-F2218FC8",
                    "Mac-F221BEC8",
                    "Mac-F221DCC8",
                    "Mac-F222BEC8",
                    "Mac-F2238AC8",
                    "Mac-F2238BAE",
                    "Mac-F223BEC8",
                    "Mac-F22586C8",
                    "Mac-F22587A1",
                    "Mac-F22587C8",
                    "Mac-F22589C8",
                    "Mac-F2268AC8",
                    "Mac-F2268CC8",
                    "Mac-F2268DAE",
                    "Mac-F2268DC8",
                    "Mac-F2268EC8",
                    "Mac-F226BEC8",
                    "Mac-F22788AA",
                    "Mac-F227BEC8",
                    "Mac-F22C86C8",
                    "Mac-F22C89C8",
                    "Mac-F22C8AC8",
                    "Mac-F42386C8",
                    "Mac-F42388C8",
                    "Mac-F4238BC8",
                    "Mac-F4238CC8",
                    "Mac-F42C86C8",
                    "Mac-F42C88C8",
                    "Mac-F42C89C8",
                    "Mac-F42D86A9",
                    "Mac-F42D86C8",
                    "Mac-F42D88C8",
                    "Mac-F42D89A9",
                    "Mac-F42D89C8"
                ],
                deviceIDs: [],
                unsupportedModelIdentifiers: []
            ),
            Installer(
                id: "10.8.5-12F45",
                version: "10.8.5",
                build: "12F45",
                date: "2013-09-27",
                distributionURL: "",
                distributionSize: 0,
                packages: [
                    Package(
                        url: "https://updates.cdn-apple.com/2021/macos/031-0627-20210614-90D11F33-1A65-42DD-BBEA-E1D9F43A6B3F/InstallMacOSX.dmg",
                        size: 4_449_317_520,
                        integrityDataURL: nil,
                        integrityDataSize: nil
                    )
                ],
                boardIDs: [
                    "Mac-00BE6ED71E35EB86",
                    "Mac-031AEE4D24BFF0B1",
                    "Mac-031B6874CF7F642A",
                    "Mac-27ADBB7B4CEE8E61",
                    "Mac-2E6FAB96566FE58C",
                    "Mac-35C1E88140C3E6CF",
                    "Mac-4B7AC7E43945597E",
                    "Mac-4BC72D62AD45599E",
                    "Mac-50619A408DB004DA",
                    "Mac-66F35F19FE2A0D05",
                    "Mac-6F01561E16C75D06",
                    "Mac-742912EFDBEE19B3",
                    "Mac-7BA5B2794B2CDB12",
                    "Mac-7DF21CB3ED6977E5",
                    "Mac-7DF2A3B5E5D671ED",
                    "Mac-8ED6AF5B48C039E1",
                    "Mac-942452F5819B1C1B",
                    "Mac-942459F5819B171B",
                    "Mac-94245A3940C91C80",
                    "Mac-94245B3640C91C81",
                    "Mac-942B59F58194171B",
                    "Mac-942B5BF58194151B",
                    "Mac-942C5DF58193131B",
                    "Mac-AFD8A9D944EA4843",
                    "Mac-C08A6BB70A942AC2",
                    "Mac-C3EC7CD22292981F",
                    "Mac-F65AE981FFA204ED",
                    "Mac-FC02E91DDD3FA6A4",
                    "Mac-F2208EC8",
                    "Mac-F2218EA9",
                    "Mac-F2218EC8",
                    "Mac-F2218FA9",
                    "Mac-F2218FC8",
                    "Mac-F221BEC8",
                    "Mac-F221DCC8",
                    "Mac-F222BEC8",
                    "Mac-F2238AC8",
                    "Mac-F2238BAE",
                    "Mac-F223BEC8",
                    "Mac-F22586C8",
                    "Mac-F22587A1",
                    "Mac-F22587C8",
                    "Mac-F22589C8",
                    "Mac-F2268AC8",
                    "Mac-F2268CC8",
                    "Mac-F2268DAE",
                    "Mac-F2268DC8",
                    "Mac-F2268EC8",
                    "Mac-F226BEC8",
                    "Mac-F22788AA",
                    "Mac-F227BEC8",
                    "Mac-F22C86C8",
                    "Mac-F22C89C8",
                    "Mac-F22C8AC8",
                    "Mac-F42386C8",
                    "Mac-F42388C8",
                    "Mac-F4238BC8",
                    "Mac-F4238CC8",
                    "Mac-F42C86C8",
                    "Mac-F42C88C8",
                    "Mac-F42C89C8",
                    "Mac-F42D86A9",
                    "Mac-F42D86C8",
                    "Mac-F42D88C8",
                    "Mac-F42D89A9",
                    "Mac-F42D89C8"
                ],
                deviceIDs: [],
                unsupportedModelIdentifiers: []
            ),
            Installer(
                id: "10.7.5-11G63",
                version: "10.7.5",
                build: "11G63",
                date: "2012-09-28",
                distributionURL: "",
                distributionSize: 0,
                packages: [
                    Package(
                        url: "https://updates.cdn-apple.com/2021/macos/041-7683-20210614-E610947E-C7CE-46EB-8860-D26D71F0D3EA/InstallMacOSX.dmg",
                        size: 4_720_237_409,
                        integrityDataURL: nil,
                        integrityDataSize: nil
                    )
                ],
                boardIDs: [
                    "Mac-2E6FAB96566FE58C",
                    "Mac-4B7AC7E43945597E",
                    "Mac-4BC72D62AD45599E",
                    "Mac-66F35F19FE2A0D05",
                    "Mac-6F01561E16C75D06",
                    "Mac-742912EFDBEE19B3",
                    "Mac-7BA5B2794B2CDB12",
                    "Mac-8ED6AF5B48C039E1",
                    "Mac-942452F5819B1C1B",
                    "Mac-942459F5819B171B",
                    "Mac-94245A3940C91C80",
                    "Mac-94245B3640C91C81",
                    "Mac-942B59F58194171B",
                    "Mac-942B5BF58194151B",
                    "Mac-942C5DF58193131B",
                    "Mac-C08A6BB70A942AC2",
                    "Mac-C3EC7CD22292981F",
                    "Mac-F2208EC8",
                    "Mac-F2218EA9",
                    "Mac-F2218EC8",
                    "Mac-F2218FA9",
                    "Mac-F2218FC8",
                    "Mac-F221BEC8",
                    "Mac-F221DCC8",
                    "Mac-F222BEC8",
                    "Mac-F2238AC8",
                    "Mac-F2238BAE",
                    "Mac-F223BEC8",
                    "Mac-F22586C8",
                    "Mac-F22587A1",
                    "Mac-F22587C8",
                    "Mac-F22589C8",
                    "Mac-F2268AC8",
                    "Mac-F2268CC8",
                    "Mac-F2268DAE",
                    "Mac-F2268DC8",
                    "Mac-F2268EC8",
                    "Mac-F226BEC8",
                    "Mac-F22788A9",
                    "Mac-F22788AA",
                    "Mac-F22788C8",
                    "Mac-F227BEC8",
                    "Mac-F22C86C8",
                    "Mac-F22C89C8",
                    "Mac-F22C8AC8",
                    "Mac-F4208AC8",
                    "Mac-F4208CA9",
                    "Mac-F4208CAA",
                    "Mac-F4208DA9",
                    "Mac-F4208DC8",
                    "Mac-F4208EAA",
                    "Mac-F42187C8",
                    "Mac-F42189C8",
                    "Mac-F4218EC8",
                    "Mac-F4218FC8",
                    "Mac-F42289C8",
                    "Mac-F4228EC8",
                    "Mac-F42386C8",
                    "Mac-F42388C8",
                    "Mac-F4238BC8",
                    "Mac-F4238CC8",
                    "Mac-F42786A9",
                    "Mac-F42C86C8",
                    "Mac-F42C88C8",
                    "Mac-F42C89C8",
                    "Mac-F42C8CC8",
                    "Mac-F42D86A9",
                    "Mac-F42D86C8",
                    "Mac-F42D88C8",
                    "Mac-F42D89A9",
                    "Mac-F42D89C8"
                ],
                deviceIDs: [],
                unsupportedModelIdentifiers: []
            )
        ]
    }

    static var filenameDescription: String {
        """
        Use the following variables to set the filename dynamically. For example:
        - **%NAME%** will be replaced with **'\(Installer.example.name)'**
        - **%VERSION%** will be replaced with **'\(Installer.example.version)'**
        - **%BUILD%** will be replaced with **'\(Installer.example.build)'**
        """
    }

    static var packageDescription: String {
        """
        Use the following variables to set the identifier dynamically. For example:
        - **%NAME%** will be replaced with **'\(Installer.example.name)'**
        - **%VERSION%** will be replaced with **'\(Installer.example.version)'**
        - **%BUILD%** will be replaced with **'\(Installer.example.build)'**
        - Spaces will be replaced with hyphens **-**
        """
    }

    let id: String
    let version: String
    let build: String
    let date: String
    let distributionURL: String
    let distributionSize: Int
    let packages: [Package]
    let boardIDs: [String]
    let deviceIDs: [String]
    let unsupportedModelIdentifiers: [String]
    var name: String {

        var name: String = ""

        if version.range(of: "^14", options: .regularExpression) != nil {
            name = "macOS Sonoma"
        } else if version.range(of: "^13", options: .regularExpression) != nil {
            name = "macOS Ventura"
        } else if version.range(of: "^12", options: .regularExpression) != nil {
            name = "macOS Monterey"
        } else if version.range(of: "^11", options: .regularExpression) != nil {
            name = "macOS Big Sur"
        } else if version.range(of: "^10\\.15", options: .regularExpression) != nil {
            name = "macOS Catalina"
        } else if version.range(of: "^10\\.14", options: .regularExpression) != nil {
            name = "macOS Mojave"
        } else if version.range(of: "^10\\.13", options: .regularExpression) != nil {
            name = "macOS High Sierra"
        } else if version.range(of: "^10\\.12", options: .regularExpression) != nil {
            name = "macOS Sierra"
        } else if version.range(of: "^10\\.11", options: .regularExpression) != nil {
            name = "OS X El Capitan"
        } else if version.range(of: "^10\\.10", options: .regularExpression) != nil {
            name = "OS X Yosemite"
        } else if version.range(of: "^10\\.9", options: .regularExpression) != nil {
            name = "OS X Mavericks"
        } else if version.range(of: "^10\\.8", options: .regularExpression) != nil {
            name = "OS X Mountain Lion"
        } else if version.range(of: "^10\\.7", options: .regularExpression) != nil {
            name = "Mac OS X Lion"
        } else {
            name = "macOS \(version)"
        }

        name = beta ? "\(name) beta" : name
        return name
    }
    var compatible: Bool {
        // Board ID (Intel)
        if let boardID: String = Hardware.boardID,
            !boardIDs.isEmpty,
            !boardIDs.contains(boardID) {
            return false
        }

        // Device ID (Apple Silicon or Intel T2)
        // macOS Big Sur 11 or newer
        if version.range(of: "^1[1-9]\\.", options: .regularExpression) != nil,
            let deviceID: String = Hardware.deviceID,
            !deviceIDs.isEmpty,
            !deviceIDs.contains(deviceID) {
            return false
        }

        // Model Identifier (Apple Silicon or Intel)
        // macOS Catalina 10.15 or older
        if version.range(of: "^10\\.", options: .regularExpression) != nil {

            if let architecture: Architecture = Hardware.architecture,
                architecture == .appleSilicon {
                return false
            }

            if let modelIdentifier: String = Hardware.modelIdentifier,
                !unsupportedModelIdentifiers.isEmpty,
                unsupportedModelIdentifiers.contains(modelIdentifier) {
                return false
            }
        }

        return true
    }
    var allDownloads: [Package] {
        (sierraOrOlder ? [] : [Package(url: distributionURL, size: distributionSize, integrityDataURL: nil, integrityDataSize: nil)]) + packages.sorted { $0.filename < $1.filename }
    }
    var temporaryDiskImageMountPointURL: URL {
        URL(fileURLWithPath: "/Volumes/\(id)")
    }
    var temporaryInstallerURL: URL {
        temporaryDiskImageMountPointURL.appendingPathComponent("/Applications/Install \(name).app")
    }
    var temporaryISOMountPointURL: URL {
        URL(fileURLWithPath: "/Volumes/Install \(name)")
    }
    var dictionary: [String: Any] {
        [
            "identifier": id,
            "name": name,
            "version": version,
            "build": build,
            "size": size,
            "date": date,
            "compatible": compatible,
            "distribution": distributionURL,
            "packages": packages.map { $0.dictionary },
            "beta": beta
        ]
    }
    var mavericksOrNewer: Bool {
        bigSurOrNewer || version.range(of: "^10\\.(9|1[0-5])\\.", options: .regularExpression) != nil
    }
    var sierraOrOlder: Bool {
        version.range(of: "^10\\.([7-9]|1[0-2])\\.", options: .regularExpression) != nil
    }
    var catalinaOrNewer: Bool {
        bigSurOrNewer || version.range(of: "^10\\.15\\.", options: .regularExpression) != nil
    }
    var bigSurOrNewer: Bool {
        version.range(of: "^1[1-9]\\.", options: .regularExpression) != nil
    }
    var beta: Bool {
        build.range(of: "[a-z]$", options: .regularExpression) != nil
    }
    var imageName: String {
        name.replacingOccurrences(of: " beta", with: "")
    }
    var size: UInt64 {
        UInt64(packages.map { $0.size }.reduce(0, +))
    }
    var diskImageSize: Double {
        ceil(Double(size) / Double(UInt64.gigabyte)) + 1.5
    }
    var isoSize: Double {
        ceil(Double(size) / Double(UInt64.gigabyte)) + 1.5
    }
    var tooltip: String {
        """
        Release: \(name)
        Version: \(version)
        Build Number: \(build)
        Release Date: \(date)
        Download Size: \(size.bytesString())
        """
    }
}

extension Installer: Equatable {

    static func == (lhs: Installer, rhs: Installer) -> Bool {
        lhs.version == rhs.version && lhs.build == rhs.build
    }
}
