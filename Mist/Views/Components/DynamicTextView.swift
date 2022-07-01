//
//  DynamicTextView.swift
//  Mist
//
//  Created by Nindi Gill on 17/6/2022.
//

import SwiftUI

struct DynamicTextView: View {
    var title: String
    @Binding var text: String
    var placeholder: String
    var stringFormatter: (_ text: String) -> String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(stringFormatter(text))
                .foregroundColor(.secondary)
        }
        TextField(placeholder, text: $text)
            .onAppear {
                DispatchQueue.main.async {
                    NSApplication.shared.keyWindow?.makeFirstResponder(nil)
                }
            }
    }
}

struct DynamicTextView_Previews: PreviewProvider {
    static var previews: some View {
        DynamicTextView(title: "Title", text: .constant("Text"), placeholder: "Placeholder") { text in
            text
        }
    }
}
