import SwiftUI
import UIKit

struct TestView: View {
    @StateObject private var viewModel = UserViewModel()
    @State private var slider1Value: Double = 0.0
    @State private var slider2Value: Double = 0.0
    @State private var validateCount: Int = 42
    @State private var isFirstButtonPressed: Bool = false
    @State private var currentFeedbackType: String?
    @State private var feedbackPlayCount: Int = 0
    @State private var currentTableau: Int = 0
    @State private var currentVibrationIndex: Int = 0
    @State private var showNextTestView: Bool = false
    @State private var showThankYouView: Bool = false
    @State private var availableFeedbackTypesTableaus: [[String]]
    @State private var isLoadingData = true

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

    init() {
        let allKeys = Array(feedbackTypes.keys)
        let tableau1 = Array(allKeys).shuffled()
        let tableau2 = Array(allKeys).shuffled()
        let tableau3 = Array(allKeys).shuffled()
        
        _availableFeedbackTypesTableaus = State(initialValue: [tableau1, tableau2, tableau3])
    }

    var body: some View {
        VStack {
            if showThankYouView {
                ThankYouView()
                    .transition(.opacity)
                    .navigationBarHidden(true)
            } else if showNextTestView {
                NextTestView()
                    .transition(.opacity)
                    .navigationBarHidden(true)
            } else {
                VStack {
                    if isLoadingData {
                        ProgressView("Chargement des données...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .onAppear {
                                loadData()
                            }
                    } else {
                        Spacer(minLength: 10)

                        Text("\(feedbackPlayCount)/3 fois")
                            .font(.subheadline)
                            .padding(.bottom, 10)

                        Button(action: {
                            if feedbackPlayCount < 3 {
                                if currentFeedbackType == nil {
                                    selectCurrentFeedbackType()
                                }
                                if let feedbackType = currentFeedbackType {
                                    feedbackTypes[feedbackType]?()
                                    feedbackPlayCount += 1
                                    isFirstButtonPressed = true
                                }
                            }
                        }) {
                            Text("Jouer la vibration")
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
                                saveVibrationAndSubmitExperience(slider1Value: slider1Value, slider2Value: slider2Value)
                                moveToNextVibrationOrTableau()
                                validateCount -= 1
                                if validateCount > 0 {
                                    showNextTestView = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        showNextTestView = false
                                    }
                                } else {
                                    showThankYouView = true
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
                        .disabled(!isFirstButtonPressed || validateCount <= 0 || isLoadingData)

                        Text("Compteur: \(validateCount)")
                            .font(.headline)
                            .padding(.bottom, 20)

                        Spacer()
                    }
                }
                .navigationBarHidden(true)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func loadData() {
        let group = DispatchGroup()

        group.enter()
        viewModel.fetchUsers()
            .sink(receiveCompletion: { _ in
                group.leave()
            }, receiveValue: { _ in })
            .store(in: &viewModel.cancellables)

        group.enter()
        viewModel.fetchTelephones()
            .sink(receiveCompletion: { _ in
                group.leave()
            }, receiveValue: { _ in })
            .store(in: &viewModel.cancellables)

        group.enter()
        viewModel.fetchVibrations()
            .sink(receiveCompletion: { _ in
                group.leave()
            }, receiveValue: { _ in })
            .store(in: &viewModel.cancellables)

        group.notify(queue: .main) {
            isLoadingData = false
        }
    }

    private func selectCurrentFeedbackType() {
        guard currentTableau < availableFeedbackTypesTableaus.count,
              currentVibrationIndex < availableFeedbackTypesTableaus[currentTableau].count else {
            return
        }
        currentFeedbackType = availableFeedbackTypesTableaus[currentTableau][currentVibrationIndex]
    }

    private func moveToNextVibrationOrTableau() {
        if currentVibrationIndex < 13 {
            currentVibrationIndex += 1
        } else {
            currentVibrationIndex = 0
            if currentTableau < 2 {
                currentTableau += 1
            } else {
                showThankYouView = true
                return
            }
        }
        resetStateForNextVibrationOrTableau()
        selectCurrentFeedbackType()
    }

    private func saveVibrationAndSubmitExperience(slider1Value: Double, slider2Value: Double) {
        guard let feedbackType = currentFeedbackType else {
            print("Erreur : le type de vibration est manquant")
            return
        }

        let vibration = Vibration(id: nil, nom_vibration: feedbackType, nombre_de_fois: feedbackPlayCount)
        viewModel.createVibration(vibration: vibration) { createdVibration in
            print("Vibration créée avec ID: \(createdVibration.id ?? 0)")
            self.submitExperience(vibrationId: createdVibration.id ?? 0, slider1Value: slider1Value, slider2Value: slider2Value)
        }
    }

    private func submitExperience(vibrationId: Int, slider1Value: Double, slider2Value: Double) {
        guard let user = viewModel.users.first,
              let telephone = viewModel.telephones.first else {
            print("Erreur : l'utilisateur ou le téléphone est manquant")
            print("Users: \(viewModel.users)")
            print("Telephones: \(viewModel.telephones)")
            return
        }

        // Log des valeurs des sliders avant soumission
        print("Submitting experience with agreabilite: \(slider1Value), intensite: \(slider2Value)")

        let experience = Experience(
            id: nil,
            agreabilite: Float(slider1Value),
            intensite: Float(slider2Value),
            user: "http://192.168.68.104:8000/api/users/\(user.id ?? 0)",
            telephone: "http://192.168.68.104:8000/api/telephones/\(telephone.id ?? 0)",
            vibration: "http://192.168.68.104:8000/api/vibrations/\(vibrationId)"
        )

        viewModel.createExperience(experience: experience)
        print("Expérience soumise : \(experience)")
    }

    private func resetStateForNextVibrationOrTableau() {
        slider1Value = 0.0
        slider2Value = 0.0
        isFirstButtonPressed = false
        feedbackPlayCount = 0
        currentFeedbackType = nil
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
