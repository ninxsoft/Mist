//
//  PathControl.swift
//  Mist
//
//  Created by Nindi Gill on 23/9/2022.
//

import SwiftUI

struct PathControl: NSViewRepresentable {

    @Binding var path: String

    func makeNSView(context: Context) -> NSPathControl {
        NSPathControl()
    }

    func updateNSView(_ nsView: NSPathControl, context: Context) {
        nsView.url = URL(fileURLWithPath: path)
    }
}

struct PathControl_Previews: PreviewProvider {
    static var previews: some View {
        PathControl(path: .constant(.cacheDirectory))
    }
}
