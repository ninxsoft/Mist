//
//  CodesigningPickerView.swift
//  Mist
//
//  Created by Nindi Gill on 17/6/2022.
//

import SwiftUI

struct CodesigningPickerView: View {
    @Binding var enabled: Bool
    var title: String
    @Binding var selection: String
    var identities: [String]

    var body: some View {
        HStack {
            Toggle(isOn: $enabled) {
                Text(title)
            }
            Picker("Picker", selection: $selection) {
                Text("Select identity...")
                    .tag("")
                Divider()
                if !identities.isEmpty {
                    ForEach(identities, id: \.self) { identity in
                        HStack {
                            ScaledImage(name: "Certificate", length: 16)
                            Text(identity)
                        }
                        .tag(identity)
                    }
                } else {
                    Text("No codesigning identities found in keychain")
                        .tag("-")
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
            .disabled(!enabled)
        }
    }
}

struct CodesigningPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CodesigningPickerView(enabled: .constant(true), title: "Codesign Disk Image:", selection: .constant("Developer ID Application"), identities: ["Developer ID Application"])
        CodesigningPickerView(enabled: .constant(true), title: "Codesign Package:", selection: .constant("Developer ID Installer"), identities: ["Developer ID Installer"])
    }
}
