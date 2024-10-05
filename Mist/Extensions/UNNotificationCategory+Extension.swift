//
//  UNNotificationCategory+Extension.swift
//  Mist
//
//  Created by Nindi Gill on 23/6/2022.
//

import UserNotifications

extension UNNotificationCategory {
    /// Mist Notification identifiers
    enum Identifier {
        /// Success Identifier
        static let success: String = "Success"
        /// Failure Identifier
        static let failure: String = "Failure"
    }
}
