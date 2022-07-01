//
//  SettingsGeneralRetryView.swift
//  Mist
//
//  Created by Nindi Gill on 17/6/2022.
//

import SwiftUI

struct SettingsGeneralRetryView: View {
    var title: String
    @Binding var value: Int
    var minimum: Int
    var maximum: Int
    var `default`: Int
    var description: String

    var body: some View {
        VStack(alignment: .leading) {
            TextFieldStepperView(title: title, value: $value, minimum: minimum, maximum: maximum, default: `default`)
            FooterText(description)
        }
    }
}

struct SettingsGeneralRetryView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsGeneralRetryView(title: "Title", value: .constant(3), minimum: 1, maximum: 10, default: 5, description: "Description")
    }
}
