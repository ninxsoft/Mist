//
//  ScaledImage.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import SwiftUI

struct ScaledImage: View {
    var name: String?
    var length: CGFloat

    var body: some View {
        if let name: String = name {
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: length, height: length)
        } else {
            Image(nsImage: NSApplication.shared.applicationIconImage)
                .resizable()
                .scaledToFit()
                .frame(width: length, height: length)
        }
    }
}

struct ScaledImage_Previews: PreviewProvider {
    static var previews: some View {
        ScaledImage(name: "macOS", length: 32)
    }
}
