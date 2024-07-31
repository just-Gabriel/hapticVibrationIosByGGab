import SwiftUI
import UIKit

struct TestView: View {
    @StateObject private var viewModel = UserViewModel()
    @State private var selectedOption = "Selection"
    @State private var slider1Value: Double = 0
    @State private var slider2Value: Double = 0
    @State private var validateCount: Int = 14
    @State private var isFirstButtonPressed: Bool = false
    @State private var usedFeedbackTypes: Set<String> = []
    @State private var currentFeedbackType: String?
    @State private var feedbackPlayCount: Int = 0
    @State private var showNextTestView: Bool = false

    let options = ["Action confirmation", "Échec", "Navigation", "Selection", "Succès", "Avertissement"]
    let accentColor = Color(hex: "#019AAF")

    var feedbackTypes: [String: () -> Void] = [
        "impactLight": {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        },
        "impactMedium": {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
        },
        "impactHeavy": {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            generator.impactOccurred()
        },
        "notificationSuccess": {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
        },
        "notificationWarning": {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.warning)
        },
        "notificationError": {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.error)
        },
        "selection": {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        },
        "sequenceImpactLightMedium": {
            let generatorLight = UIImpactFeedbackGenerator(style: .light)
            let generatorMedium = UIImpactFeedbackGenerator(style: .medium)
            generatorLight.prepare()
            generatorLight.impactOccurred()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                generatorMedium.prepare()
                generatorMedium.impactOccurred()
            }
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
        "sequenceNotificationSuccessError": {
            let generatorSuccess = UINotificationFeedbackGenerator()
            let generatorError = UINotificationFeedbackGenerator()
            generatorSuccess.prepare()
            generatorSuccess.notificationOccurred(.success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                generatorError.prepare()
                generatorError.notificationOccurred(.error)
            }
        },
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
        "loopImpactLight": {
            let generator = UIImpactFeedbackGenerator(style: .light)
            for _ in 1...3 {
                generator.prepare()
                generator.impactOccurred()
                usleep(100_000) // 100 ms
            }
        },
        "loopImpactMedium": {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            for _ in 1...3 {
                generator.prepare()
                generator.impactOccurred()
                usleep(150_000) // 150 ms
            }
        },
        "loopImpactHeavy": {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            for _ in 1...3 {
                generator.prepare()
                generator.impactOccurred()
                usleep(200_000) // 200 ms
            }
        }
    ]

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
                            if let feedbackType = currentFeedbackType ?? feedbackTypes.keys.filter({ !usedFeedbackTypes.contains($0) }).randomElement() {
                                feedbackTypes[feedbackType]?()
                                currentFeedbackType = feedbackType
                                feedbackPlayCount += 1
                                isFirstButtonPressed = true
                                if feedbackPlayCount == 3 {
                                    saveVibration(feedbackType: feedbackType, count: feedbackPlayCount)
                                }
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
                    .disabled(feedbackPlayCount >= 3 || validateCount <= 0)

                    VStack {
                        Text("Agréabilité \(Int(slider1Value))")
                        CustomSliderWithTicks(value: $slider1Value, range: -5...5, accentColor: accentColor, step: 1)
                            .padding()

                        Text("Intensité \(Int(slider2Value))")
                        CustomSliderWithTicks(value: $slider2Value, range: -5...5, accentColor: accentColor, step: 1)
                            .padding()
                    }
                    .disabled(validateCount <= 0)

                    CustomPicker(selectedOption: $selectedOption, options: options, accentColor: accentColor)
                        .frame(width: 200)
                        .padding(.top, 20)
                        .disabled(validateCount <= 0)

                    Spacer()

                    Button(action: {
                        if isFirstButtonPressed {
                            submitExperience()
                            validateCount -= 1
                            slider1Value = 0
                            slider2Value = 0
                            isFirstButtonPressed = false
                            feedbackPlayCount = 0
                            currentFeedbackType = nil
                            if validateCount > 0 {
                                showNextTestView = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    showNextTestView = false
                                }
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

                    Text("Tests restant: \(validateCount)")
                        .font(.headline)
                        .padding(.bottom, 20)

                    Spacer()
                }
                .navigationBarHidden(true)
                .onAppear {
                    viewModel.fetchUsers()
                    viewModel.fetchTelephones()
                    viewModel.fetchVibrations()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func saveVibration(feedbackType: String, count: Int) {
        let vibration = Vibration(id: nil, nom_vibration: feedbackType, nombre_de_fois: count)
        viewModel.createVibration(vibration: vibration)
    }

    private func submitExperience() {
        guard let userId = viewModel.users.first?.id,
              let telephoneId = viewModel.telephones.first?.id,
              let feedbackType = currentFeedbackType,
              let vibration = viewModel.vibrations.first(where: { $0.nom_vibration == feedbackType }) else {
            print("Erreur : l'utilisateur, le téléphone ou le type de vibration est manquant")
            return
        }

        let experience = Experience(
            id: nil,
            agreabilite: Int(slider1Value),
            intensite: Int(slider2Value),
            impression: selectedOption,
            userId: userId,
            telephoneId: telephoneId,
            vibrationId: vibration.id ?? 0
        )

        viewModel.createExperience(experience: experience)
        print("Expérience soumise : \(experience)")
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
