//
//  PaddedDivider.swift
//  Mist
//
//  Created by Nindi Gill on 17/6/2022.
//

import SwiftUI

struct PaddedDivider: View {
    private let padding: CGFloat = 5

    var body: some View {
        Divider()
            .padding(.vertical, padding)
    }
}

struct PaddedDivider_Previews: PreviewProvider {
    static var previews: some View {
        PaddedDivider()
    }
}
