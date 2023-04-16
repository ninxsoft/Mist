//
//  SettingsGeneralView.swift
//  Mist
//
//  Created by Nindi Gill on 15/6/2022.
//

import SwiftUI

struct SettingsGeneralView: View {
    @AppStorage("enableNotifications")
    private var enableNotifications: Bool = false
    @AppStorage("retries")
    private var retries: Int = 10
    @AppStorage("retryDelay")
    private var retryDelay: Int = 30
    @AppStorage("SUEnableAutomaticChecks")
    private var enableAutomaticChecks: Bool = true
    @AppStorage("SUScheduledCheckInterval")
    private var scheduledCheckInterval: Int = 86_400
    @ObservedObject var sparkleUpdater: SparkleUpdater
    private let enableNotificationsDefault: Bool = false
    private let retriesDefault: Int = 10
    private let retriesMinimum: Int = 0
    private let retriesMaximum: Int = 100
    private let retriesDescription: String = "Number of attempts to retry downloading before failing."
    private let retryDelayDefault: Int = 30
    private let retryDelayMinimum: Int = 1
    private let retryDelayMaximum: Int = 300
    private let retryDelayDescription: String = "Number of seconds to wait before attempting to retry downloading."
    private let enableAutomaticChecksDefault: Bool = true
    private let scheduledCheckIntervalDefault: Int = 86_400
    private let width: CGFloat = 150

    var body: some View {
        VStack(alignment: .leading) {
            SettingsGeneralHelperView()
            PaddedDivider()
            SettingsGeneralNotificationsView(enableNotifications: $enableNotifications)
            PaddedDivider()
            SettingsGeneralRetryView(title: "Retry attempts:", value: $retries, minimum: retriesMinimum, maximum: retriesMaximum, default: retriesDefault, description: retriesDescription)
            SettingsGeneralRetryView(title: "Retry delay:", value: $retryDelay, minimum: retryDelayMinimum, maximum: retryDelayMaximum, default: retryDelayDefault, description: retryDelayDescription)
            PaddedDivider()
            SettingsGeneralUpdatesView(sparkleUpdater: sparkleUpdater, enable: $enableAutomaticChecks, interval: $scheduledCheckInterval, width: width)
            PaddedDivider()
            ResetToDefaultButton {
                reset()
            }
        }
        .padding()
    }

    private func reset() {
        enableNotifications = enableNotificationsDefault
        retries = retriesDefault
        retryDelay = retryDelayDefault
        enableAutomaticChecks = enableAutomaticChecksDefault
        scheduledCheckInterval = scheduledCheckIntervalDefault
    }
}

struct SettingsGeneralView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsGeneralView(sparkleUpdater: SparkleUpdater())
    }
}
