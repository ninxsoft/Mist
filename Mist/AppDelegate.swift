//
//  AppDelegate.swift
//  Mist
//
//  Created by Nindi Gill on 16/6/2022.
//

import AppKit
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate {
    // swiftlint:disable:next weak_delegate
    private let userNotificationCenterDelegate: UserNotificationCenterDelegate = .init()

    func applicationDidFinishLaunching(_: Notification) {
        UNUserNotificationCenter.current().delegate = userNotificationCenterDelegate
        let show: UNNotificationAction = .init(identifier: UNNotificationAction.Identifier.show, title: "Show", options: .foreground)
        let success: UNNotificationCategory = .init(identifier: UNNotificationCategory.Identifier.success, actions: [show], intentIdentifiers: [], options: [])
        let failure: UNNotificationCategory = .init(identifier: UNNotificationCategory.Identifier.failure, actions: [], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([success, failure])

        NSWindow.allowsAutomaticWindowTabbing = false
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        true
    }

    func sendUpdateNotification(title: String, body: String, success: Bool, url: URL?) {
        let notificationCenter: UNUserNotificationCenter = .current()
        notificationCenter.getNotificationSettings { settings in

            guard [.authorized, .provisional].contains(settings.authorizationStatus) else {
                return
            }

            let identifier: String = UUID().uuidString
            let content: UNMutableNotificationContent = .init()
            content.title = title
            content.body = body
            content.sound = .default
            content.categoryIdentifier = success ? UNNotificationCategory.Identifier.success : UNNotificationCategory.Identifier.failure

            if
                success,
                let url: URL = url {
                content.userInfo = ["URL": url.path]
            }

            let trigger: UNTimeIntervalNotificationTrigger = .init(timeInterval: 1, repeats: false)
            let request: UNNotificationRequest = .init(identifier: identifier, content: content, trigger: trigger)

            notificationCenter.add(request) { error in

                if let error: Error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
