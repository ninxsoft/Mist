//
//  ScaledSystemImage.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import SwiftUI

struct ScaledSystemImage: View {
    var systemName: String
    var length: CGFloat
    var renderingMode: SymbolRenderingMode = .monochrome

    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .frame(width: length, height: length)
            .symbolRenderingMode(renderingMode)
    }
}

struct ScaledSystemImage_Previews: PreviewProvider {
    static var previews: some View {
        ScaledSystemImage(systemName: "applelogo", length: 32)
    }
}
