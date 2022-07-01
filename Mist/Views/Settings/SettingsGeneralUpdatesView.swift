//
//  SettingsGeneralUpdatesView.swift
//  Mist
//
//  Created by Nindi Gill on 17/6/2022.
//

import SwiftUI

struct SettingsGeneralUpdatesView: View {
    @ObservedObject var sparkleUpdater: SparkleUpdater
    @Binding var enable: Bool
    @Binding var interval: Int
    var width: CGFloat

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Toggle(isOn: $enable) {
                    Text("Automatically check for app updates:")
                }
                Picker("Scheduled Check Interval", selection: $interval) {
                    Text("Once a day")
                        .tag(86_400)
                    Text("Once a week")
                        .tag(86_400 * 7)
                    Text("Once a fortnight")
                        .tag(86_400 * 14)
                    Text("Once a month")
                        .tag(86_400 * 30)
                }
                .labelsHidden()
                .disabled(!enable)
                .frame(width: width)
                Spacer()
                Button("Check now...") {
                    checkForUpdates()
                }
            }
            FooterText("You will be notified and given the option to proceed when an update is available.")
        }
    }

    private func checkForUpdates() {
        sparkleUpdater.checkForUpdates()
    }
}

struct SettingsGeneralUpdatesView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsGeneralUpdatesView(sparkleUpdater: SparkleUpdater(), enable: .constant(true), interval: .constant(86_400), width: 150)
    }
}
