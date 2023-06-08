//
//  Hardware.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import Foundation

/// Hardware Struct used to retrieve Hardware information.
struct Hardware {

    /// Hardware Architecture (Apple Silicon or Intel).
    static var architecture: Architecture? {
        #if arch(arm64)
            return .appleSilicon
        #elseif arch(x86_64)
            return .intel
        #else
            return nil
        #endif
    }

    /// Hardware Board ID (Intel).
    static var boardID: String? {
        architecture == .intel ? registryProperty(for: "board-id") : nil
    }
    /// Hardware Device ID (Apple Silicon or Intel T2).
    static var deviceID: String? {

        switch architecture {
        case .appleSilicon:
            return registryProperty(for: "compatible")?.components(separatedBy: "\0").first?.uppercased()
        case .intel:
            return registryProperty(for: "bridge-model")?.uppercased()
        default:
            return nil
        }
    }
    /// Hardware Model Identifier (Apple Silicon or Intel).
    static var modelIdentifier: String? {
        registryProperty(for: "model")
    }

    /// Retrieves the IOKit Registry **IOPlatformExpertDevice** entity property for the provided key.
    ///
    /// - Parameters:
    ///   - key: The key for the entity property.
    ///
    /// - Returns: The entity property for the provided key.
    private static func registryProperty(for key: String) -> String? {

        let entry: io_service_t = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPlatformExpertDevice"))

        defer {
            IOObjectRelease(entry)
        }

        var properties: Unmanaged<CFMutableDictionary>?

        guard IORegistryEntryCreateCFProperties(entry, &properties, kCFAllocatorDefault, 0) == KERN_SUCCESS,
            let properties: Unmanaged<CFMutableDictionary> = properties else {
            return nil
        }

        let nsDictionary: NSDictionary = properties.takeRetainedValue() as NSDictionary

        guard let dictionary: [String: Any] = nsDictionary as? [String: Any],
            dictionary.keys.contains(key),
            let data: Data = IORegistryEntryCreateCFProperty(entry, key as CFString, kCFAllocatorDefault, 0).takeRetainedValue() as? Data,
            let string: String = String(data: data, encoding: .utf8) else {
            return nil
        }

        return string.trimmingCharacters(in: CharacterSet(["\0"]))
    }
}
