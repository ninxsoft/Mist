//
//  TextFieldStepperView.swift
//  Mist
//
//  Created by Nindi Gill on 16/6/2022.
//

import SwiftUI

struct TextFieldStepperView: View {
    var title: String
    @Binding var value: Int
    var minimum: Int
    var maximum: Int
    var `default`: Int
    private let width: CGFloat = 40

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            TextField("\(`default`)", value: $value, formatter: NumberFormatter())
                .frame(width: width)
            Stepper {
                Text(title)
            } onIncrement: {
                increment()
            } onDecrement: {
                decrement()
            }
            .labelsHidden()
        }
    }

    private func increment() {

        if value < maximum {
            value += 1
        }
    }

    private func decrement() {

        if value > minimum {
            value -= 1
        }
    }
}

struct TextFieldStepperView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldStepperView(title: "Title", value: .constant(3), minimum: 1, maximum: 10, default: 5)
    }
}
