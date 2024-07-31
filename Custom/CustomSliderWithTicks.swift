import SwiftUI
import UIKit

struct CustomSliderWithTicks: View {
    @Binding var value: Double
    var range: ClosedRange<Double>
    var accentColor: Color
    var step: Double

    var body: some View {
        VStack {
            Slider(value: $value, in: range, step: step)
                .accentColor(accentColor)
                .overlay(
                    HStack {
                        ForEach(Array(stride(from: range.lowerBound, through: range.upperBound, by: step)), id: \.self) { tickValue in
                            Spacer()
                            Rectangle()
                                .fill(accentColor)
                                .frame(width: 1, height: 10)
                            Spacer()
                        }
                    }
                )
        }
    }
}
