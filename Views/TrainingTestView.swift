import SwiftUI
import UIKit

struct TrainingTestView: View {
    @State private var slider1Value: Double = 0.0
    @State private var slider2Value: Double = 0.0
    @State private var validateCount: Int = 5
    @State private var isFirstButtonPressed: Bool = false
    @State private var currentFeedbackType: String?
    @State private var feedbackPlayCount: Int = 0
    @State private var showNextTestView: Bool = false
    @State private var navigateToRealTest = false
    @State private var availableFeedbackTypes: [String] = []

    let accentColor = Color(hex: "#019AAF")

    var feedbackTypes: [String: () -> Void] = [
        
        "loopImpactHeavy": {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            for _ in 1...3 {
                generator.prepare()
                generator.impactOccurred()
                usleep(200_000) // 200 ms
            }
        },
        
//        "impactMedium": {
//            let generator = UIImpactFeedbackGenerator(style: .medium)
//            generator.prepare()
//            generator.impactOccurred()
//        },
        "impactHeavy": {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            generator.impactOccurred()
        },
        
        "sequenceImpactHeavyRigid": {
            if #available(iOS 13.0, *) {
                let generatorHeavy = UIImpactFeedbackGenerator(style: .heavy)
                let generatorRigid = UIImpactFeedbackGenerator(style: .rigid)
                generatorHeavy.prepare()
                generatorHeavy.impactOccurred()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    generatorRigid.prepare()
                    generatorRigid.impactOccurred()
                }
            }
        },
        "notificationWarning": {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.warning)
        },
//        "notificationError": {
//            let generator = UINotificationFeedbackGenerator()
//            generator.prepare()
//            generator.notificationOccurred(.error)
//        },
        "sequenceSelectionImpactLight": {
            let generatorSelection = UISelectionFeedbackGenerator()
            let generatorLight = UIImpactFeedbackGenerator(style: .light)
            generatorSelection.prepare()
            generatorSelection.selectionChanged()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                generatorLight.prepare()
                generatorLight.impactOccurred()
            }
        },
    ]

    init() {
        _availableFeedbackTypes = State(initialValue: Array(feedbackTypes.keys).shuffled())
    }

    var body: some View {
        VStack {
            if showNextTestView {
                NextTestView()
                    .transition(.opacity)
                    .navigationBarHidden(true)
            } else {
                VStack {
                    Spacer(minLength: 10)

                    Text("Vibration \(feedbackPlayCount)/3")
                        .font(.subheadline)
                        .padding(.bottom, 10)

                    Button(action: {
                        if feedbackPlayCount < 3 {
                            if currentFeedbackType == nil {
                                selectUniqueFeedbackType()
                            }
                            if let feedbackType = currentFeedbackType {
                                feedbackTypes[feedbackType]?()
                                feedbackPlayCount += 1
                                isFirstButtonPressed = true
                            }
                        }
                    }) {
                        Text("Vibration")
                            .padding()
                            .background(feedbackPlayCount < 3 ? accentColor : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 30)
                    .disabled(validateCount <= 0)

                    Spacer()

                    VStack {
                        HStack {
                            Text("Désagréable")
                                .font(.caption)
                                .foregroundColor(.black)
                            Spacer()
                            Text(String(format: "%.1f", slider1Value))
                                .font(.caption)
                                .foregroundColor(.white)
                            Spacer()
                            Text("Agréable")
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal)

                        CustomSliderWithTicks(value: $slider1Value, range: -5.0...5.0, accentColor: accentColor, step: 0.1)
                            .padding()

                        HStack {
                            Text("Faible")
                                .font(.caption)
                                .foregroundColor(.black)
                            Spacer()
                            Text(String(format: "%.1f", slider2Value))
                                .font(.caption)
                                .foregroundColor(.white)
                            Spacer()
                            Text("Intense")
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal)

                        CustomSliderWithTicks(value: $slider2Value, range: 0.0...10, accentColor: accentColor, step: 0.4)
                            .padding()
                    }
                    .padding(.bottom, 30)
                    .disabled(validateCount <= 0)

                    Spacer()

                    Button(action: {
                        if isFirstButtonPressed {
                            resetStateForNextTest()
                            validateCount -= 1
                            if validateCount > 0 {
                                showNextTestView = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    showNextTestView = false
                                }
                            } else {
                                navigateToRealTest = true
                            }
                        }
                    }) {
                        Text("Valider")
                            .padding(20)
                            .background(accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                    .disabled(validateCount <= 0)

                    Text("Compteur: \(validateCount)")
                        .font(.headline)
                        .padding(.bottom, 20)

                    Spacer()
                }
                .navigationBarHidden(true)
            }
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $navigateToRealTest) {
            RealTestStartView() // Assurez-vous que RealTestStartView n'a pas d'arguments requis
        }
        .onAppear {
            availableFeedbackTypes = Array(feedbackTypes.keys).shuffled()
        }
    }

    private func selectUniqueFeedbackType() {
        guard !availableFeedbackTypes.isEmpty else {
            return
        }
        currentFeedbackType = availableFeedbackTypes.removeFirst()
    }

    private func resetStateForNextTest() {
        slider1Value = 0.0
        slider2Value = 0.0
        isFirstButtonPressed = false
        feedbackPlayCount = 0
        currentFeedbackType = nil
    }
}

struct TrainingTestView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingTestView()
    }
}
