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
    @Binding var fade: Bool
    var duration: CGFloat = 0.5
    private let length: CGFloat = 48

    var body: some View {
        HStack(alignment: .top) {
            ScaledImage(name: imageName, length: length)
                .opacity(fade ? 0 : 1)
                .animation(.easeInOut(duration: duration), value: fade)
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
        SettingsHeaderView(imageName: "Firmware", title: "Title", description: "Description", fade: .constant(false))
    }
}
