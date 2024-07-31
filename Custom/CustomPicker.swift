//
//  CustomPicker.swift
//  ProjetiPhone12
//
//  Created by Ortega Gabriel on 19/06/2024.
//
import SwiftUI

struct CustomPicker: View {
    @Binding var selectedOption: String
    var options: [String]
    var accentColor: Color

    var body: some View {
        Picker("Options", selection: $selectedOption) {
            ForEach(options, id: \.self) { option in
                Text(option)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .accentColor(accentColor)
    }
}
