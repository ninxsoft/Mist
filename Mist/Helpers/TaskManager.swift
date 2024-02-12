//
//  TaskManager.swift
//  Mist
//
//  Created by Nindi Gill on 20/6/2022.
//

import Foundation
import System

// swiftlint:disable file_length
// swiftlint:disable:next type_body_length
class TaskManager: ObservableObject {
    static let shared: TaskManager = .init()
    @Published var taskGroups: [(section: MistTaskSection, tasks: [MistTask])]
    var task: Task<Any, Error> = Task {}

    var currentState: MistTaskState {
        let states: Set<MistTaskState> = Set(taskGroups.flatMap(\.tasks).map(\.state))

        if states.contains(.inProgress) {
            return .inProgress
        }

        if states.contains(.error) {
            return .error
        }

        if states.contains(.pending) {
            return .pending
        }

        return .complete
    }

    init(taskGroups: [(section: MistTaskSection, tasks: [MistTask])] = []) {
        self.taskGroups = taskGroups
    }

    static func taskGroups(for firmware: Firmware, destination destinationURL: URL?, retries: Int, delay retryDelay: Int) throws -> [(section: MistTaskSection, tasks: [MistTask])] {
        let temporaryDirectoryURL: URL = .init(fileURLWithPath: .temporaryDirectory)

        guard let destinationURL: URL = destinationURL else {
            throw MistError.invalidDestinationURL
        }

        guard let firmwareURL: URL = URL(string: firmware.url) else {
            throw MistError.invalidURL(firmware.url)
        }

        let temporaryFirmwareURL: URL = temporaryDirectoryURL.appendingPathComponent(firmwareURL.lastPathComponent)

        return [
            (
                section: .setup,
                tasks: firmwareSetupTasks(
                    temporaryDirectory: temporaryDirectoryURL
                )
            ),
            (
                section: .download,
                tasks: firmwareDownloadTasks(
                    firmware: firmware,
                    firmwareURL: firmwareURL,
                    temporaryFirmware: temporaryFirmwareURL,
                    destination: destinationURL,
                    retries: retries,
                    delay: retryDelay
                )
            ),
            (
                section: .cleanup,
                tasks: firmwareCleanupTasks(
                    temporaryDirectory: temporaryDirectoryURL
                )
            )
        ]
    }

    private static func firmwareSetupTasks(temporaryDirectory temporaryDirectoryURL: URL) -> [MistTask] {
        [
            MistTask(type: .configure, description: "temporary directory") {
                LogManager.shared.log(.info, message: "Configuring temporary directory '\(temporaryDirectoryURL.path)'...")
                try await DirectoryCreator.create(temporaryDirectoryURL)
            }
        ]
    }

    // swiftlint:disable:next function_parameter_count
    private static func firmwareDownloadTasks(
        firmware: Firmware,
        firmwareURL: URL,
        temporaryFirmware temporaryFirmwareURL: URL,
        destination destinationURL: URL,
        retries: Int,
        delay retryDelay: Int
    ) -> [MistTask] {
        var tasks: [MistTask] = [
            MistTask(type: .download, description: firmwareURL.lastPathComponent, downloadSize: firmware.size) {
                LogManager.shared.log(.info, message: "Downloading '\(firmwareURL.absoluteString)' to '\(temporaryFirmwareURL.path)'...")
                try await DownloadManager.shared.download(firmwareURL, to: temporaryFirmwareURL, retries: retries, delay: retryDelay)
            }
        ]

        if !firmware.shasum.isEmpty {
            tasks += [
                MistTask(type: .verify, description: firmwareURL.lastPathComponent) {
                    LogManager.shared.log(.info, message: "Verifying '\(temporaryFirmwareURL.path)'...")
                    try await Validator.validate(firmware, at: temporaryFirmwareURL)
                }
            ]
        }

        tasks += [
            MistTask(type: .move, description: "Firmware to destination") {
                LogManager.shared.log(.info, message: "Moving '\(temporaryFirmwareURL.path)' to destination '\(destinationURL.path)'...")
                try await FileMover.move(temporaryFirmwareURL, to: destinationURL)
            }
        ]

        return tasks
    }

    private static func firmwareCleanupTasks(temporaryDirectory temporaryDirectoryURL: URL) -> [MistTask] {
        [
            MistTask(type: .remove, description: "temporary directory") {
                LogManager.shared.log(.info, message: "Removing temporary directory '\(temporaryDirectoryURL.path)'...")
                try await DirectoryRemover.remove(temporaryDirectoryURL)
            }
        ]
    }

    // swiftlint:disable:next function_body_length function_parameter_count
    static func taskGroups(
        for installer: Installer,
        destination destinationURL: URL?,
        exports: [InstallerExportType],
        cacheDownloads: Bool,
        cacheDirectory: String,
        retries: Int,
        delay retryDelay: Int,
        applicationFilename: String,
        diskImageFilename: String,
        diskImageSign: Bool,
        diskImageSigningIdentity: String,
        isoFilename: String,
        packageFilename: String,
        packageIdentifier: String,
        packageSign: Bool,
        packageSigningIdentity: String
    ) throws -> [(section: MistTaskSection, tasks: [MistTask])] {
        var taskGroups: [(section: MistTaskSection, tasks: [MistTask])] = []
        let cacheDirectoryURL: URL = .init(fileURLWithPath: cacheDirectory).appendingPathComponent(installer.id)
        let temporaryDirectoryURL: URL = .init(fileURLWithPath: .temporaryDirectory)

        guard let destinationURL: URL = destinationURL else {
            throw MistError.invalidDestinationURL
        }

        try taskGroups += [
            (
                section: .download,
                tasks: downloadTasks(for: installer, cacheDirectory: cacheDirectoryURL, retries: retries, delay: retryDelay)
            )
        ]

        if !installer.bigSurOrNewer || exports != [.package] {
            taskGroups += [
                (
                    section: .setup,
                    tasks: installTasks(for: installer, temporaryDirectory: temporaryDirectoryURL, mountPoint: installer.temporaryDiskImageMountPointURL, cacheDirectory: cacheDirectory)
                )
            ]
        }

        if exports.contains(.application) {
            taskGroups += [
                (
                    section: .application,
                    tasks: applicationTasks(for: installer, filename: applicationFilename, destination: destinationURL)
                )
            ]
        }

        if exports.contains(.diskImage) {
            taskGroups += [
                (
                    section: .diskImage,
                    // swiftlint:disable:next line_length
                    tasks: diskImageTasks(for: installer, filename: diskImageFilename, sign: diskImageSign, identity: diskImageSigningIdentity, destination: destinationURL, temporaryDirectory: temporaryDirectoryURL)
                )
            ]
        }

        if exports.contains(.iso) {
            taskGroups += [
                (
                    section: .iso,
                    tasks: isoTasks(for: installer, filename: isoFilename, destination: destinationURL, temporaryDirectory: temporaryDirectoryURL)
                )
            ]
        }

        if exports.contains(.package) {
            taskGroups += [
                (
                    section: .package,
                    // swiftlint:disable:next line_length
                    tasks: packageTasks(for: installer, filename: packageFilename, identifier: packageIdentifier, sign: packageSign, identity: packageSigningIdentity, destination: destinationURL, temporaryDirectory: temporaryDirectoryURL, cacheDirectory: cacheDirectoryURL)
                )
            ]
        }

        if !installer.bigSurOrNewer || exports != [.package] {
            taskGroups += [
                (
                    section: .cleanup,
                    tasks: cleanupTasks(
                        mountPoint: installer.temporaryDiskImageMountPointURL,
                        temporaryDirectory: temporaryDirectoryURL,
                        cacheDownloads: cacheDownloads,
                        cacheDirectory: cacheDirectoryURL
                    )
                )
            ]
        }

        return taskGroups
    }

    // swiftlint:disable:next function_parameter_count
    static func taskGroups(
        for installer: Installer,
        cacheDownloads: Bool,
        cacheDirectory: String,
        retries: Int,
        delay retryDelay: Int,
        volume: InstallerVolume
    ) throws -> [(section: MistTaskSection, tasks: [MistTask])] {
        let cacheDirectoryURL: URL = .init(fileURLWithPath: cacheDirectory).appendingPathComponent(installer.id)
        let temporaryDirectoryURL: URL = .init(fileURLWithPath: .temporaryDirectory)
        let taskGroups: [(section: MistTaskSection, tasks: [MistTask])] = try [
            (
                section: .download,
                tasks: downloadTasks(for: installer, cacheDirectory: cacheDirectoryURL, retries: retries, delay: retryDelay)
            ),
            (
                section: .setup,
                tasks: installTasks(for: installer, temporaryDirectory: temporaryDirectoryURL, mountPoint: installer.temporaryDiskImageMountPointURL, cacheDirectory: cacheDirectory)
            ),
            (
                section: .bootableInstaller,
                tasks: bootableInstallerTasks(for: installer, volume: volume)
            ),
            (
                section: .cleanup,
                tasks: cleanupTasks(
                    mountPoint: installer.temporaryDiskImageMountPointURL,
                    temporaryDirectory: temporaryDirectoryURL,
                    cacheDownloads: cacheDownloads,
                    cacheDirectory: cacheDirectoryURL
                )
            )
        ]

        return taskGroups
    }

    private static func downloadTasks(for installer: Installer, cacheDirectory cacheDirectoryURL: URL, retries: Int, delay retryDelay: Int) throws -> [MistTask] {
        var tasks: [MistTask] = []

        if !FileManager.default.fileExists(atPath: cacheDirectoryURL.path) {
            tasks += [
                MistTask(type: .configure, description: "cache directory") {
                    LogManager.shared.log(.info, message: "Configuring cache directory '\(cacheDirectoryURL.path)'...")
                    try await DirectoryCreator.create(cacheDirectoryURL, withIntermediateDirectories: true)
                }
            ]
        } else {
            let attributes: [FileAttributeKey: Any] = try FileManager.default.attributesOfItem(atPath: cacheDirectoryURL.path)

            guard
                let posixPermissions: NSNumber = attributes[.posixPermissions] as? NSNumber,
                let ownerAccountName: String = attributes[.ownerAccountName] as? String,
                let groupOwnerAccountName: String = attributes[.groupOwnerAccountName] as? String else {
                throw MistError.missingFileAttributes
            }

            let filePermissions: FilePermissions = .init(rawValue: CModeT(posixPermissions.int16Value))

            if filePermissions != [.ownerReadWriteExecute, .groupReadExecute, .otherReadExecute] || ownerAccountName != NSUserName() || groupOwnerAccountName != "wheel" {
                tasks += [
                    MistTask(type: .configure, description: "cache directory") {
                        LogManager.shared.log(.info, message: "Configuring cache directory '\(cacheDirectoryURL.path)'...")
                        try await FileAttributesUpdater.update(url: cacheDirectoryURL, ownerAccountName: ownerAccountName)
                    }
                ]
            }
        }

        for package in installer.allDownloads {
            guard let packageURL: URL = URL(string: package.url) else {
                throw MistError.invalidURL(package.url)
            }

            let cachePackageURL: URL = cacheDirectoryURL.appendingPathComponent(packageURL.lastPathComponent)

            tasks += [
                MistTask(type: .download, description: package.filename, downloadSize: UInt64(package.size)) {
                    LogManager.shared.log(.info, message: "Downloading '\(packageURL.absoluteString)' to '\(cachePackageURL.path)'...")
                    try await DownloadManager.shared.download(packageURL, to: cachePackageURL, retries: retries, delay: retryDelay)
                },
                MistTask(type: .verify, description: package.filename) {
                    LogManager.shared.log(.info, message: "Verifying '\(cachePackageURL.path)'...")
                    try await Validator.validate(package, at: cachePackageURL)
                }
            ]
        }

        return tasks
    }

    // swiftlint:disable:next function_body_length
    private static func installTasks(for installer: Installer, temporaryDirectory temporaryDirectoryURL: URL, mountPoint mountPointURL: URL, cacheDirectory: String) -> [MistTask] {
        let imageURL: URL = temporaryDirectoryURL.appendingPathComponent("\(installer.id) Temp.dmg")
        var tasks: [MistTask] = [
            MistTask(type: .configure, description: "temporary directory") {
                LogManager.shared.log(.info, message: "Configuring temporary directory '\(temporaryDirectoryURL.path)'...")
                try await DirectoryCreator.create(temporaryDirectoryURL)
            },
            MistTask(type: .create, description: "Disk Image") {
                LogManager.shared.log(.info, message: "Creating Disk Image '\(imageURL.path)'...")
                try await DiskImageCreator.create(imageURL, size: installer.diskImageSize)
            },
            MistTask(type: .mount, description: "Disk Image") {
                LogManager.shared.log(.info, message: "Mounting Disk Image '\(imageURL.path)' at mount point '\(mountPointURL.path)'...")
                try await DiskImageMounter.mount(imageURL, mountPoint: mountPointURL)
            }
        ]

        if
            installer.sierraOrOlder,
            let package: Package = installer.packages.first {
            let legacyDiskImageURL: URL = .init(fileURLWithPath: "\(cacheDirectory)/\(installer.id)/\(package.filename)")
            let legacyDiskImageMountPointURL: URL = .init(fileURLWithPath: "/Volumes/Install \(installer.name)")

            tasks += [
                MistTask(type: .mount, description: "Installer Disk Image") {
                    LogManager.shared.log(.info, message: "Mounting Disk Image '\(legacyDiskImageURL.path)' at mount point '\(legacyDiskImageMountPointURL.path)'...")
                    try await DiskImageMounter.mount(legacyDiskImageURL, mountPoint: legacyDiskImageMountPointURL)
                },
                MistTask(type: .create, description: "Installer in Disk Image") {
                    LogManager.shared.log(.info, message: "Creating Installer in Disk Image at mount point '\(mountPointURL.path)' using cache directory '\(cacheDirectory)/\(installer.id)'...")
                    try await InstallerCreator.create(installer, mountPoint: mountPointURL, cacheDirectory: cacheDirectory)
                },
                MistTask(type: .unmount, description: "Installer Disk Image") {
                    LogManager.shared.log(.info, message: "Unmounting Installer Disk Image at mount point '\(legacyDiskImageMountPointURL.path)'...")
                    try await DiskImageUnmounter.unmount(legacyDiskImageMountPointURL)
                }
            ]
        } else {
            tasks += [
                MistTask(type: .create, description: "macOS Installer in Disk Image") {
                    LogManager.shared.log(.info, message: "Creating macOS Installer in Disk Image at mount point '\(mountPointURL.path)' using cache directory '\(cacheDirectory)/\(installer.id)'...")
                    try await InstallerCreator.create(installer, mountPoint: mountPointURL, cacheDirectory: cacheDirectory)

                    guard let major: Substring = installer.version.split(separator: ".").first else {
                        return
                    }

                    let source: URL = mountPointURL.appendingPathComponent("Applications/Install macOS \(major) beta.app")
                    let destination: URL = mountPointURL.appendingPathComponent("Applications/Install \(installer.name).app")

                    guard FileManager.default.fileExists(atPath: source.path) else {
                        return
                    }

                    LogManager.shared.log(.info, message: "Moving '\(source.path)' to '\(destination.path)'...")
                    try await FileMover.move(source, to: destination)
                }
            ]
        }

        return tasks
    }

    private static func applicationTasks(for installer: Installer, filename: String, destination destinationURL: URL) -> [MistTask] {
        let applicationURL: URL = destinationURL.appendingPathComponent(filename.stringWithSubstitutions(name: installer.name, version: installer.version, build: installer.build))

        return [
            MistTask(type: .copy, description: "Application to destination") {
                LogManager.shared.log(.info, message: "Copying Application '\(installer.temporaryInstallerURL.path)' to destination '\(applicationURL.path)'...")
                try await FileCopier.copy(installer.temporaryInstallerURL, to: applicationURL)
            }
        ]
    }

    // swiftlint:disable:next function_parameter_count
    private static func diskImageTasks(
        for installer: Installer,
        filename: String,
        sign diskImageSign: Bool,
        identity diskImageSigningIdentity: String,
        destination destinationURL: URL,
        temporaryDirectory temporaryDirectoryURL: URL
    ) -> [MistTask] {
        let imageDirectoryURL: URL = temporaryDirectoryURL.appendingPathComponent(installer.id)
        let applicationURL: URL = imageDirectoryURL.appendingPathComponent(installer.temporaryInstallerURL.lastPathComponent)
        let temporaryImageURL: URL = temporaryDirectoryURL.appendingPathComponent("\(installer.id).dmg")
        let imageURL: URL = destinationURL.appendingPathComponent(filename.stringWithSubstitutions(name: installer.name, version: installer.version, build: installer.build))
        var tasks: [MistTask] = [
            MistTask(type: .configure, description: "temporary Disk Image directory") {
                LogManager.shared.log(.info, message: "Configuring temporary Disk Image directory '\(imageDirectoryURL.path)'...")
                try await DirectoryCreator.create(imageDirectoryURL)
            },
            MistTask(type: .copy, description: "macOS Installer to temporary Disk Image directory") {
                LogManager.shared.log(.info, message: "Copying macOS Installer '\(installer.temporaryInstallerURL.path)' to temporary Disk Image directory '\(applicationURL.path)'...")
                try await FileCopier.copy(installer.temporaryInstallerURL, to: applicationURL)
            },
            MistTask(type: .create, description: "Disk Image") {
                LogManager.shared.log(.info, message: "Creating Disk Image '\(temporaryImageURL.path)' from '\(imageDirectoryURL.path)'...")
                try await DiskImageCreator.create(temporaryImageURL, from: imageDirectoryURL)
            },
            MistTask(type: .remove, description: "temporary Disk Image directory") {
                LogManager.shared.log(.info, message: "Removing temporary Disk Image directory '\(imageDirectoryURL.path)'...")
                try await DirectoryRemover.remove(imageDirectoryURL)
            }
        ]

        if diskImageSign, !diskImageSigningIdentity.isEmpty, diskImageSigningIdentity != "-" {
            tasks += [
                MistTask(type: .codesign, description: "Disk Image") {
                    LogManager.shared.log(.info, message: "Codesigning Disk Image '\(temporaryImageURL.path)' using signing identity '\(diskImageSigningIdentity)'...")
                    try await Codesigner.sign(temporaryImageURL, identity: diskImageSigningIdentity)
                }
            ]
        }

        tasks += [
            MistTask(type: .move, description: "Disk Image to destination") {
                LogManager.shared.log(.info, message: "Moving Disk Image '\(temporaryImageURL.path)' to destination '\(imageURL.path)'...")
                try await FileMover.move(temporaryImageURL, to: imageURL)
            }
        ]
        return tasks
    }

    // swiftlint:disable:next function_body_length
    private static func isoTasks(for installer: Installer, filename: String, destination destinationURL: URL, temporaryDirectory temporaryDirectoryURL: URL) -> [MistTask] {
        let temporaryImageURL: URL = temporaryDirectoryURL.appendingPathComponent("\(installer.id).dmg")
        let createInstallMediaURL: URL = installer.temporaryInstallerURL.appendingPathComponent("Contents/Resources/createinstallmedia")
        let temporaryCDRURL: URL = temporaryDirectoryURL.appendingPathComponent("\(installer.id).cdr")
        let isoURL: URL = destinationURL.appendingPathComponent(filename.stringWithSubstitutions(name: installer.name, version: installer.version, build: installer.build))

        if installer.mavericksOrNewer {
            return [
                MistTask(type: .create, description: "temporary Disk Image") {
                    LogManager.shared.log(.info, message: "Creating temporary Disk Image '\(temporaryImageURL.path)'...")
                    try await DiskImageCreator.create(temporaryImageURL, size: installer.isoSize)
                },
                MistTask(type: .mount, description: "temporary Disk Image") {
                    LogManager.shared.log(.info, message: "Mounting temporary Disk Image '\(temporaryImageURL.path)' at mount point '\(installer.temporaryISOMountPointURL.path)'...")
                    try await DiskImageMounter.mount(temporaryImageURL, mountPoint: installer.temporaryISOMountPointURL)
                },
                MistTask(type: .create, description: "macOS Installer in temporary Disk Image") {
                    // Workaround to make macOS Sierra 10.12 createinstallmedia work
                    if installer.version.hasPrefix("10.12") {
                        let infoPlistURL: URL = installer.temporaryInstallerURL.appendingPathComponent("Contents/Info.plist")
                        LogManager.shared.log(.info, message: "Updating Property List '\(infoPlistURL.path)'...")
                        try PropertyListUpdater.update(infoPlistURL, key: "CFBundleShortVersionString", value: "12.6.03")
                    }

                    // swiftlint:disable:next line_length
                    LogManager.shared.log(.info, message: "Creating macOS Installer in temporary Disk Image at mount point '\(installer.temporaryISOMountPointURL.path)' using createinstallmedia '\(createInstallMediaURL.path)'...")
                    try await InstallMediaCreator.create(createInstallMediaURL, mountPoint: installer.temporaryISOMountPointURL, sierraOrOlder: installer.sierraOrOlder)
                },
                MistTask(type: .unmount, description: "temporary Disk Image") {
                    if FileManager.default.fileExists(atPath: installer.temporaryISOMountPointURL.path) {
                        LogManager.shared.log(.info, message: "Unmounting temporary Disk Image at mount point '\(installer.temporaryISOMountPointURL.path)'...")
                        try await DiskImageUnmounter.unmount(installer.temporaryISOMountPointURL)
                    }

                    guard let major: Substring = installer.version.split(separator: ".").first else {
                        return
                    }

                    let url: URL = .init(fileURLWithPath: "/Volumes/Install macOS \(major) beta")

                    if FileManager.default.fileExists(atPath: url.path) {
                        LogManager.shared.log(.info, message: "Unmounting temporary Disk Image at mount point '\(url.path)'...")
                        try await DiskImageUnmounter.unmount(url)
                    }
                },
                MistTask(type: .convert, description: "temporary Disk Image to ISO") {
                    LogManager.shared.log(.info, message: "Converting temporary Disk Image '\(temporaryImageURL.path)' to ISO '\(temporaryCDRURL.path)'...")
                    try await ISOConverter.convert(temporaryImageURL, destination: temporaryCDRURL)
                },
                MistTask(type: .move, description: "ISO to destination") {
                    LogManager.shared.log(.info, message: "Moving ISO '\(temporaryCDRURL.path)' to destination '\(isoURL.path)'...")
                    try await FileMover.move(temporaryCDRURL, to: isoURL)
                }
            ]
        } else {
            let installESDURL: URL = installer.temporaryInstallerURL.appendingPathComponent("Contents/SharedSupport/InstallESD.dmg")
            return [
                MistTask(type: .convert, description: "Installer Disk Image to ISO") {
                    LogManager.shared.log(.info, message: "Converting Installer Disk Image '\(installESDURL.path)' to ISO '\(temporaryCDRURL.path)'...")
                    try await ISOConverter.convert(installESDURL, destination: temporaryCDRURL)
                },
                MistTask(type: .move, description: "ISO to destination") {
                    LogManager.shared.log(.info, message: "Moving ISO '\(temporaryCDRURL.path)' to destination '\(isoURL.path)'...")
                    try await FileMover.move(temporaryCDRURL, to: isoURL)
                }
            ]
        }
    }

    // swiftlint:disable:next function_parameter_count
    private static func packageTasks(
        for installer: Installer,
        filename: String,
        identifier packageIdentifier: String,
        sign packageSign: Bool,
        identity packageSigningIdentity: String,
        destination destinationURL: URL,
        temporaryDirectory temporaryDirectoryURL: URL,
        cacheDirectory cacheDirectoryURL: URL
    ) -> [MistTask] {
        let packageURL: URL = destinationURL.appendingPathComponent(filename.stringWithSubstitutions(name: installer.name, version: installer.version, build: installer.build))
        var tasks: [MistTask] = []

        if installer.bigSurOrNewer {
            let sourceURL: URL = cacheDirectoryURL.appendingPathComponent("InstallAssistant.pkg")

            tasks = [
                MistTask(type: .copy, description: "Package to destination") {
                    LogManager.shared.log(.info, message: "Copying Package '\(sourceURL.path)' to destination '\(packageURL.path)'...")
                    try await FileCopier.copy(sourceURL, to: packageURL)
                }
            ]
        } else {
            let temporaryPackageURL: URL = temporaryDirectoryURL.appendingPathComponent("\(installer.id).pkg")
            let identifier: String = packageIdentifier.stringWithSubstitutions(name: installer.name, version: installer.version, build: installer.build).replacingOccurrences(of: " ", with: "-")
            let identity: String? = (packageSign && !packageSigningIdentity.isEmpty && packageSigningIdentity != "-") ? packageSigningIdentity : nil

            tasks = [
                MistTask(type: .create, description: "Package") {
                    LogManager.shared.log(.info, message: "Creating Package '\(temporaryPackageURL.path)'...")
                    try await PackageCreator.create(temporaryPackageURL, from: installer, identifier: identifier, identity: identity)
                },
                MistTask(type: .move, description: "Package to destination") {
                    LogManager.shared.log(.info, message: "Moving Package '\(temporaryPackageURL.path)' to destination '\(packageURL.path)'...")
                    try await FileMover.move(temporaryPackageURL, to: packageURL)
                }
            ]
        }

        return tasks
    }

    private static func bootableInstallerTasks(for installer: Installer, volume: InstallerVolume) -> [MistTask] {
        let createInstallMediaURL: URL = installer.temporaryInstallerURL.appendingPathComponent("Contents/Resources/createinstallmedia")
        let mountPointURL: URL = .init(fileURLWithPath: volume.path)
        let tasks: [MistTask] = [
            MistTask(type: .create, description: "Bootable Installer") {
                // Workaround to make macOS Sierra 10.12 createinstallmedia work
                if installer.version.hasPrefix("10.12") {
                    let infoPlistURL: URL = installer.temporaryInstallerURL.appendingPathComponent("Contents/Info.plist")
                    LogManager.shared.log(.info, message: "Updating Property List '\(infoPlistURL.path)'...")
                    try PropertyListUpdater.update(infoPlistURL, key: "CFBundleShortVersionString", value: "12.6.03")
                }

                LogManager.shared.log(.info, message: "Creating Bootable Installer at mount point '\(mountPointURL.path)' using createinstallmedia '\(createInstallMediaURL.path)'...")
                try await InstallMediaCreator.create(createInstallMediaURL, mountPoint: mountPointURL, sierraOrOlder: installer.sierraOrOlder)
            }
        ]

        return tasks
    }

    private static func cleanupTasks(mountPoint mountPointURL: URL, temporaryDirectory temporaryDirectoryURL: URL, cacheDownloads: Bool, cacheDirectory cacheDirectoryURL: URL) -> [MistTask] {
        var tasks: [MistTask] = [
            MistTask(type: .unmount, description: "Disk Image") {
                LogManager.shared.log(.info, message: "Unmounting Disk Image at mount point '\(mountPointURL.path)'...")
                try await DiskImageUnmounter.unmount(mountPointURL)
            },
            MistTask(type: .remove, description: "temporary directory") {
                LogManager.shared.log(.info, message: "Removing temporary directory '\(temporaryDirectoryURL.path)'...")
                try await DirectoryRemover.remove(temporaryDirectoryURL)
            }
        ]

        if !cacheDownloads {
            tasks += [
                MistTask(type: .remove, description: "cache directory") {
                    LogManager.shared.log(.info, message: "Removing cache directory '\(cacheDirectoryURL.path)'...")
                    try await DirectoryRemover.remove(cacheDirectoryURL)
                }
            ]
        }

        return tasks
    }

    func cancelTask() {
        task.cancel()
    }
}
