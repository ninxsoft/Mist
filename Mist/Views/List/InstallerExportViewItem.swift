//
//  InstallerExportViewItem.swift
//  Mist
//
//  Created by Nindi Gill on 28/6/2022.
//

import SwiftUI

struct InstallerExportViewItem: View {
    var exportType: InstallerExportType
    @Binding var selected: Bool
    private let length: CGFloat = 24

    var body: some View {
        HStack {
            Toggle(isOn: $selected) {}
            Group {
                ScaledSystemImage(systemName: exportType.systemName, length: length)
                    .foregroundColor(.accentColor)
                Text(exportType.description)
            }
            .onTapGesture {
                selected.toggle()
            }
        }
        .padding(.horizontal)
    }
}

struct InstallerExportViewItem_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(InstallerExportType.allCases) { exportType in
            InstallerExportViewItem(exportType: exportType, selected: .constant(false))
        }
    }
}
