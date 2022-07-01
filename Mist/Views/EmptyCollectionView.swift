//
//  EmptyCollectionView.swift
//  Mist
//
//  Created by Nindi Gill on 1/7/2022.
//

import SwiftUI

struct EmptyCollectionView: View {
    var description: String

    var body: some View {
        Text(description)
            .font(.largeTitle)
            .multilineTextAlignment(.center)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    init(_ description: String) {
        self.description = description
    }
}

struct EmptyCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyCollectionView("Description")
    }
}
