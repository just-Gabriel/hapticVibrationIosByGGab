//
//  CustomSlider.swift
//  ProjetiPhone12
//
//  Created by Ortega Gabriel on 19/06/2024.
//
import SwiftUI

struct CustomSlider: View {
    @Binding var value: Double
    var range: ClosedRange<Double>
    var accentColor: Color

    var body: some View {
        Slider(value: $value, in: range)
            .accentColor(accentColor)
    }
}

