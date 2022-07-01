//
//  TextTag.swift
//  Mist
//
//  Created by Nindi Gill on 13/6/2022.
//

import SwiftUI

struct TextTag: View {
    var title: String
    private let padding: CGFloat = 5
    private let cornerRadius: CGFloat = 5
    private let color: Color = .accentColor

    var body: some View {
        Text(title)
            .foregroundColor(.white)
            .padding(padding)
            .background(color)
            .cornerRadius(cornerRadius)
    }
}

struct TextTag_Previews: PreviewProvider {
    static var previews: some View {
        TextTag(title: "Beta")
    }
}
