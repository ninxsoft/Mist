//
//  RefreshRowView.swift
//  Mist
//
//  Created by Nindi Gill on 17/6/2022.
//

import SwiftUI

struct RefreshRowView: View {
    var image: String
    var title: String
    @Binding var state: RefreshState
    @State private var degrees: CGFloat = 0
    private let leadingImageLength: CGFloat = 32
    private let trailingImageLength: CGFloat = 18
    private var animation: Animation {
        state == .inProgress ? .linear(duration: 1.0).repeatForever(autoreverses: false) : .default
    }

    var body: some View {
        HStack {
            ScaledSystemImage(systemName: image, length: leadingImageLength)
                .foregroundColor(.accentColor)
            Text(title)
            Spacer()
            ScaledSystemImage(systemName: state.systemName, length: trailingImageLength, renderingMode: .palette)
                .foregroundStyle((state == .warning ? .black : .white), state.color)
                .rotationEffect(.degrees(degrees))
                .animation(animation, value: degrees)
        }
        .onChange(of: state) { state in
            degrees = state == .inProgress ? 360 : 0
        }
    }
}

struct RefreshRowView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(RefreshState.allCases) { state in
            RefreshRowView(image: "memorychip", title: "Firmwares...", state: .constant(state))
            RefreshRowView(image: "desktopcomputer.and.arrow.down", title: "Installers...", state: .constant(state))
        }
    }
}
