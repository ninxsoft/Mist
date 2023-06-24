//
//  TextRibbon.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import SwiftUI

struct TextRibbon: View {
    var title: String
    var length: CGFloat

    var body: some View {
        Text(title)
            .foregroundColor(.white)
            .frame(width: length)
            .background(Color.accentColor)
            .mask(Circle().frame(width: length, height: length))
    }
}

struct TextRibbon_Previews: PreviewProvider {
    static var previews: some View {
        TextRibbon(title: "BETA", length: 48)
    }
}
