//
//  DownloadSectionHeaderView.swift
//  Mist
//
//  Created by Nindi Gill on 25/6/2022.
//

import SwiftUI

struct DownloadSectionHeaderView: View {
    var section: MistTaskSection
    private let length: CGFloat = 24

    var body: some View {
        HStack {
            Text(section.description)
                .font(.title2)
                .foregroundColor(.secondary)
            Spacer()
            ScaledImage(name: section.image, length: length)
        }
        .padding()
    }
}

struct DownloadSectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(MistTaskSection.allCases) { section in
            DownloadSectionHeaderView(section: section)
        }
    }
}
