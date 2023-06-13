//
//  ActivityRowView.swift
//  Mist
//
//  Created by Nindi Gill on 28/6/2022.
//

import SwiftUI

struct ActivityRowView: View {
    var state: MistTaskState
    var description: String
    var degrees: CGFloat
    private let length: CGFloat = 16

    var body: some View {
        HStack {
            if state == .inProgress {
                ScaledSystemImage(systemName: state.imageName, length: length, renderingMode: .palette)
                    .foregroundStyle(.white, state.color)
                    .rotationEffect(.degrees(degrees))
                    .animation(state == .inProgress ? .linear(duration: 1.0).repeatForever(autoreverses: false) : .default, value: degrees)
            } else {
                ScaledSystemImage(systemName: state.imageName, length: length, renderingMode: .palette)
                    .foregroundStyle(.white, state.color)
            }
            Text(description)
            Spacer()
        }
    }
}

struct ActivityRowView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRowView(state: .inProgress, description: "Downloading...", degrees: 360)
    }
}
