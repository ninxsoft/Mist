//
//  FloatingAlert.swift
//  Mist
//
//  Created by Nindi Gill on 25/1/2024.
//

import Foundation
import SwiftUI

struct FloatingAlert: View {
    var image: String
    var message: String
    private let length: CGFloat = 200
    private let imageLength: CGFloat = 160
    private let cornerRadius: CGFloat = 20

    var body: some View {
        VStack {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
            Text(message)
                .font(.title)
                .fontWeight(.medium)
        }
        .foregroundStyle(.secondary)
        .padding()
        .frame(width: length, height: length)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
    }
}

struct FloatingAlert_Previews: PreviewProvider {
    static var previews: some View {
        FloatingAlert(image: "list.bullet.clipboard.fill", message: "Copied to Clipboard")
    }
}
