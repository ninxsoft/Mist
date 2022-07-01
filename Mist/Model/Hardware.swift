//
//  Hardware.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import Foundation

/// Hardware Struct used to retrieve Hardware information.
struct Hardware {

    /// Hardware Architecture (arm64 or x86_64).
    static var architecture: String? {

        guard let cString: UnsafePointer<CChar> = NXGetLocalArchInfo().pointee.name else {
            return nil
        }

        return String(cString: cString)
    }

    /// Hardware Board ID (Intel).
    static var boardID: String? {

        guard let architecture: String = architecture else {
            return nil
        }

        return architecture.contains("x86_64") ? registryProperty(for: "board-id") : nil
    }
    /// Hardware Device ID (Apple Silicon or Intel T2).
    static var deviceID: String? {

        guard let architecture: String = architecture else {
            return nil
        }

        if architecture.contains("x86_64") {
            return registryProperty(for: "bridge-model")?.uppercased()
        } else {
            return registryProperty(for: "compatible")?.components(separatedBy: "\0").first?.uppercased()
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
