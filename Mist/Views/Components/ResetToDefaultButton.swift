//
//  ResetToDefaultButton.swift
//  Mist
//
//  Created by Nindi Gill on 16/6/2022.
//

import SwiftUI

struct ResetToDefaultButton: View {
    var action: () -> Void

    var body: some View {
        HStack {
            Spacer()
            Button("Reset to Default") {
                action()
            }
        }
    }
}

struct ResetToDefaultButton_Previews: PreviewProvider {
    static var previews: some View {
        ResetToDefaultButton { }
    }
}
