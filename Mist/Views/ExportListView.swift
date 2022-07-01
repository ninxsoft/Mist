//
//  ExportListView.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import SwiftUI

struct ExportListView: View {
    @Binding var exportListType: ExportListType

    var body: some View {
        HStack {
            Spacer()
            Picker("Export Type:", selection: $exportListType) {
                ForEach(ExportListType.allCases) { type in
                    Text(type.description)
                        .tag(type)
                }
            }
            .pickerStyle(.menu)
        }
        .padding()
    }
}

struct ExportListView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ExportListType.allCases) { type in
            ExportListView(exportListType: .constant(type))
        }
    }
}
