//
//  InstallerVolumeSelectionInformationView.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2023.
//

import SwiftUI

struct InstallerVolumeSelectionInformationView: View {
    private let spacing: CGFloat = 10

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            HStack(alignment: .top) {
                Image(systemName: "info.circle.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.white, Color.blue)
                    .font(.title)
                Text("Only volumes formatted as **Mac OS Extended (Journaled)** are available for selection. Use **Disk Utility** to format volumes as required.")
            }
            HStack(alignment: .top) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.black, Color.yellow)
                    .font(.title)
                Text("The selected volume will be **erased automatically**. Ensure you have backed up any necessary data before proceeding.")
            }
        }
    }
}

struct InstallerVolumeSelectionInformationView_Previews: PreviewProvider {
    static var previews: some View {
        InstallerVolumeSelectionInformationView()
    }
}
