//
//  InstallerVolumeSelectionPickerView.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2023.
//

import SwiftUI

struct InstallerVolumeSelectionPickerView: View {
    @Binding var selectedVolume: InstallerVolume
    var volumes: [InstallerVolume]
    var refresh: () -> Void

    var body: some View {
        HStack {
            Picker("Selected Volume", selection: $selectedVolume) {
                if volumes.isEmpty {
                    Text(InstallerVolume.invalid.name)
                        .tag(InstallerVolume.invalid)
                } else {
                    Text(InstallerVolume.placeholder.name)
                        .tag(InstallerVolume.placeholder)
                    Divider()
                    ForEach(volumes) { volume in
                        Text("\(volume.name) - \(volume.capacity.bytesString())")
                            .tag(volume)
                    }
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
            Button {
                refresh()
            } label: {
                Image(systemName: "arrow.clockwise")
                    .foregroundColor(.accentColor)
            }
            .help("Refresh")
        }
        .padding(.vertical)
    }
}

struct InstallerVolumeSelectionPickerView_Previews: PreviewProvider {
    static var previews: some View {
        InstallerVolumeSelectionPickerView(selectedVolume: .constant(.placeholder), volumes: []) { }
    }
}
