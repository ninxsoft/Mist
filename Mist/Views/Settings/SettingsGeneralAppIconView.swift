//
//  SettingsGeneralAppIconView.swift
//  Mist
//
//  Created by Nindi Gill on 25/2/2024.
//

import SwiftUI

struct SettingsGeneralAppIconView: View {
    @Binding var appIcon: AppIcon
    private let length: CGFloat = 64

    var body: some View {
        VStack {
            HStack {
                Picker("App Icon:", selection: $appIcon) {
                    ForEach(AppIcon.allCases) { icon in
                        VStack {
                            ScaledImage(name: icon.previewName, length: length)
                            Text(icon.description)
                        }
                        .padding(.trailing)
                        .tag(icon)
                    }
                }
                .pickerStyle(.radioGroup)
                .horizontalRadioGroupLayout()
            }
        }
        .onChange(of: appIcon) { icon in
            setAppIcon(appIcon: icon)
        }
    }

    private func setAppIcon(appIcon: AppIcon) {
        NSApplication.shared.applicationIconImage = NSImage(named: appIcon.name)
    }
}

struct SettingsGeneralAppIconView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsGeneralAppIconView(appIcon: .constant(.default))
    }
}
