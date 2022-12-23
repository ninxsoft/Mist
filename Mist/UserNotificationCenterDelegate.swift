//
//  UserNotificationCenterDelegate.swift
//  Mist
//
//  Created by Nindi Gill on 23/6/2022.
//

import AppKit
import UserNotifications

class UserNotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {

        guard response.actionIdentifier == UNNotificationAction.Identifier.show,
            let string: String = response.notification.request.content.userInfo["URL"] as? String else {
            return
        }

        let url: URL = URL(fileURLWithPath: string)
        NSWorkspace.shared.selectFile(url.path, inFileViewerRootedAtPath: "")
    }
}
