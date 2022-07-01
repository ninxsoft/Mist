//
//  SettingsView.swift
//  Mist
//
//  Created by Nindi Gill on 15/6/2022.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var sparkleUpdater: SparkleUpdater
    private let width: CGFloat = 540

    var body: some View {
        TabView {
            SettingsGeneralView(sparkleUpdater: sparkleUpdater)
            .tabItem { Label("General", systemImage: "gear") }
            SettingsFirmwaresView()
            .tabItem { Label("Firmwares", systemImage: "memorychip") }
            SettingsInstallersView()
            .tabItem { Label("Installers", systemImage: "desktopcomputer.and.arrow.down") }
            SettingsApplicationsView()
            .tabItem { Label("Applications", systemImage: "macwindow") }
            SettingsDiskImagesView()
            .tabItem { Label("Disk Images", systemImage: "opticaldiscdrive") }
            SettingsISOsView()
            .tabItem { Label("ISOs", systemImage: "opticaldisc") }
            SettingsPackagesView()
            .tabItem { Label("Packages", systemImage: "shippingbox") }
            SettingsAboutView()
            .tabItem { Label("About", systemImage: "info.circle") }
        }
        .frame(width: width)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(sparkleUpdater: SparkleUpdater())
    }
}
