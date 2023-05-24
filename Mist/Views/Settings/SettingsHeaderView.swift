//
//  SettingsHeaderView.swift
//  Mist
//
//  Created by Nindi Gill on 16/6/2022.
//

import SwiftUI

struct SettingsHeaderView: View {
    var imageName: String
    var title: String
    var description: String
    private let length: CGFloat = 48

    var body: some View {
        HStack(alignment: .top) {
            ScaledImage(name: imageName, length: length)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title2)
                FooterText(description)
            }
        }
    }
}

struct SettingsHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsHeaderView(imageName: "Firmware", title: "Title", description: "Description")
    }
}
