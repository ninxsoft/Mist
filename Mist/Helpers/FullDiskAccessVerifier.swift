//
//  FullDiskAccessVerifier.swift
//  Mist
//
//  Created by Nindi Gill on 1/6/2023.
//

import SQLite

/// Helper struct to verify Full Disk Access.
struct FullDiskAccessVerifier {

    private enum AuthValue: Int {
        case denied = 0
        case unknown = 1
        case allowed = 2
        case limited = 3
    }

    /// TCC Service identifier for Full Disk Access
    private static let kTCCServiceSystemPolicyAllFiles: String = "kTCCServiceSystemPolicyAllFiles"

    /// Verifies if the app has Full Disk Access.
    ///
    /// - Returns: `true` if the app has Full Disk Access, otherwise `false`.
    static func isAllowed() -> Bool {
        do {
            let database: Connection = try Connection("/Library/Application Support/com.apple.TCC/TCC.db")
            let service: Expression = Expression<String>("service")
            let client: Expression = Expression<String>("client")
            let authValue: Expression = Expression<Int>("auth_value")
            let access: Table = Table("access").filter(service == kTCCServiceSystemPolicyAllFiles && client == String.appIdentifier)
            var allowed: Bool = false

            for row in try database.prepare(access) where row[authValue] == AuthValue.allowed.rawValue {
                allowed = true
                break
            }

            return allowed
        } catch {
            // print(error.localizedDescription)
            return false
        }
    }
}
