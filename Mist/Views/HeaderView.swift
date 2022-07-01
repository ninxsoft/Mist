//
//  HeaderView.swift
//  Mist
//
//  Created by Nindi Gill on 23/6/2022.
//

import SwiftUI

struct HeaderView: View {
    @Binding var downloadType: DownloadType

    var body: some View {
        Picker("Download Type", selection: $downloadType) {
            ForEach(DownloadType.allCases) { downloadType in
                Text("\(downloadType.description)s")
                    .tag(downloadType)
            }
        }
        .pickerStyle(.segmented)
        .labelsHidden()
        .padding()
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(DownloadType.allCases) { downloadType in
            HeaderView(downloadType: .constant(downloadType))
        }
    }
}
