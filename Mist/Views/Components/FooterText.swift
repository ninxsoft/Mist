//
//  FooterText.swift
//  Mist
//
//  Created by Nindi Gill on 16/6/2022.
//

import SwiftUI

struct FooterText: View {
    let string: String

    var body: some View {
        Text(.init(string))
            .foregroundColor(.secondary)
            .font(.footnote)
            .fixedSize(horizontal: false, vertical: true)
    }

    init(_ string: String) {
        self.string = string
    }
}

struct FooterText_Previews: PreviewProvider {
    static var previews: some View {
        FooterText("Example!")
    }
}
