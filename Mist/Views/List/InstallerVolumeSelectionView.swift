//
//  InstallerVolumeSelectionView.swift
//  Mist
//
//  Created by Nindi Gill on 12/6/2023.
//

import SwiftUI

struct InstallerVolumeSelectionView: View {
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    @Binding var volume: InstallerVolume?
    @State private var selectedVolume: InstallerVolume = .placeholder
    @State private var volumes: [InstallerVolume] = [.placeholder]
    private let padding: CGFloat = 5
    private let width: CGFloat = 420
    private let height: CGFloat = 320

    var body: some View {
        VStack(spacing: 0) {
            Text("Create a Bootable Installer for macOS")
                .font(.title2)
                .padding(.vertical)
            Divider()
            Spacer()
            VStack {
                Text("Select a volume to create a bootable macOS Installer:")
                InstallerVolumeSelectionPickerView(selectedVolume: $selectedVolume, volumes: volumes, refresh: refresh)
                InstallerVolumeSelectionInformationView()
            }
            .padding(.horizontal)
            .padding(.vertical, padding)
            Spacer()
            Divider()
            HStack {
                Button("Open Disk Utility") {
                    openDiskUtility()
                }
                Spacer()
                Button("Select") {
                    volume = selectedVolume
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled([InstallerVolume.placeholder, InstallerVolume.invalid].contains(selectedVolume))
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding()
        }
        .frame(width: width, height: height)
        .onAppear {
            refresh()
        }
    }

    private func refresh() {
        volumes = getAvailableVolumes()
        selectedVolume = volumes.isEmpty ? InstallerVolume.invalid : InstallerVolume.placeholder
    }

    private func getAvailableVolumes() -> [InstallerVolume] {

        var volumes: [InstallerVolume] = []
        let keys: [URLResourceKey] = [.volumeNameKey, .volumeLocalizedFormatDescriptionKey, .volumeIsReadOnlyKey, .volumeTotalCapacityKey]

        guard let urls: [URL] = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: keys, options: [.skipHiddenVolumes]) else {
            return []
        }

        for url in urls {
            do {
                let resourceValues: URLResourceValues = try url.resourceValues(forKeys: Set(keys))

                guard let volumeName: String = resourceValues.volumeName,
                    let volumeLocalizedFormatDescription: String = resourceValues.volumeLocalizedFormatDescription,
                    let volumeIsReadOnly: Bool = resourceValues.volumeIsReadOnly,
                    let volumeTotalCapacity: Int = resourceValues.volumeTotalCapacity,
                    volumeLocalizedFormatDescription == "Mac OS Extended (Journaled)",
                    !volumeIsReadOnly else {
                    continue
                }

                let volume: InstallerVolume = InstallerVolume(id: UUID().uuidString, name: volumeName, path: url.path, capacity: UInt64(volumeTotalCapacity))
                volumes.append(volume)
            } catch {
                continue
            }
        }

        return volumes
    }

    private func openDiskUtility() {
        let url: URL = URL(fileURLWithPath: "/System/Applications/Utilities/Disk Utility.app")
        NSWorkspace.shared.open(url)
    }
}

struct InstallerVolumeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        InstallerVolumeSelectionView(volume: .constant(.placeholder))
    }
}
