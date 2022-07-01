//
//  SettingsGeneralNotificationsView.swift
//  Mist
//
//  Created by Nindi Gill on 23/6/2022.
//

import SwiftUI
import UserNotifications

struct SettingsGeneralNotificationsView: View {
    @Binding var enableNotifications: Bool
    @State private var showAlert: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Toggle(isOn: $enableNotifications) {
                    Text("Enable Notifications")
                }
                Spacer()
                Button("Notifications...") {
                    openNotifications()
                }
            }
            FooterText("Receive a notification in Notification Centre when a macOS Firmware or Installer successfully downloads or fails.")
        }
        .onAppear {
            validateNotifications()
        }
        .onChange(of: enableNotifications) { boolean in
            if boolean {
                request()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("There was an error enabling notifications!"),
                message: Text("Visit Notification Centre settings to manually allow Notifications."),
                primaryButton: .default(Text("OK")),
                secondaryButton: .default(Text("Notifications...")) { openNotifications() }
            )
        }
    }

    private func validateNotifications() {

        let notificationCenter: UNUserNotificationCenter = .current()
        notificationCenter.getNotificationSettings { settings in

            guard [.authorized, .provisional].contains(settings.authorizationStatus) else {
                enableNotifications = false
                return
            }
        }
    }

    private func request() {

        let userNotificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]

        userNotificationCenter.requestAuthorization(options: options) { success, _ in

            guard success else {
                enableNotifications = false
                showAlert = true
                return
            }
        }
    }

    private func openNotifications() {

        guard let url: URL = URL(string: "x-apple.systempreferences:com.apple.preference.notifications?Notifications") else {
            return
        }

        NSWorkspace.shared.open(url)
    }
}

struct SettingsGeneralNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsGeneralNotificationsView(enableNotifications: .constant(false))
    }
}
