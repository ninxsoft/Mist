//
//  ActivityProgressView.swift
//  Mist
//
//  Created by Nindi Gill on 28/6/2022.
//

import SwiftUI

struct ActivityProgressView: View {
    var state: MistTaskState
    var value: CGFloat
    var size: UInt64
    private let padding: CGFloat = 24

    var body: some View {
        VStack {
            ProgressView(value: state == .complete ? 1 : value, total: 1)
            HStack {
                Text(percentageString(state == .complete ? 1 : value))
                    .multilineTextAlignment(.leading)
                Spacer()
                Text(progressString(for: size, progress: state == .complete ? 1 : value))
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding(.leading, padding)
    }

    private func progressString(for size: UInt64, progress: Double) -> String {
        "\((Double(size) * progress).bytesString()) of \(size.bytesString())"
    }

    private func percentageString(_ value: Double) -> String {
        String(format: "%.2f%% completed", value * 100)
    }
}

struct ActivityProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityProgressView(state: .inProgress, value: 0.5, size: Firmware.example.size)
        ActivityProgressView(state: .inProgress, value: 0.5, size: Installer.example.size)
    }
}
