import SwiftUI
import UIKit

struct TestView: View {
    @StateObject private var viewModel = UserViewModel()
    @State private var slider1Value: Double = 0.0
    @State private var slider2Value: Double = 5.0
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
    @State private var currentUserId: Int?
    @State private var currentPhoneId: Int?

    let accentColor = Color(hex: "#019AAF")

    var vibrationString = [
        "impactLight": 21, "impactMedium": 22, "impactHeavy": 23,
        "notificationSuccess": 24, "notificationWarning": 25, "notificationError": 26,
        "selection": 27, "sequenceImpactLightMedium": 28, "sequenceImpactHeavyRigid": 29,
        "sequenceNotificationSuccessError": 30, "sequenceSelectionImpactLight": 31,
        "loopImpactLight": 32, "loopImpactMedium": 33, "loopImpactHeavy": 34
    ]
    
    //liste des vibrations
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

         

    init(userId: Int, phoneId: Int) {
        let allKeys = Array(feedbackTypes.keys)
        let tableau1 = allKeys.shuffled()
        let tableau2 = allKeys.shuffled()
        let tableau3 = allKeys.shuffled()

        _availableFeedbackTypesTableaus = State(initialValue: [tableau1, tableau2, tableau3])
        _currentUserId = State(initialValue: userId)
        _currentPhoneId = State(initialValue: phoneId)
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
                            CustomSliderWithTicks(value: $slider1Value, range: -5.0...5.0, accentColor: accentColor, step: 0.1)
                                .padding()
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

        

        private func regenerateFeedbackTableau() -> [String] {
            return Array(feedbackTypes.keys).shuffled()

        }
    
    private func moveToNextVibrationOrTableau() {
            if currentVibrationIndex < availableFeedbackTypesTableaus[currentTableau].count - 1 {
                currentVibrationIndex += 1
            } else {
                availableFeedbackTypesTableaus[currentTableau] = regenerateFeedbackTableau()
                currentVibrationIndex = 0

                if currentTableau < availableFeedbackTypesTableaus.count - 1 {
                    currentTableau += 1
                } else {
                    currentTableau = 0
                    showThankYouView = true
                    return
                }
            }
          
            resetStateForNextVibrationOrTableau()
            selectCurrentFeedbackType()

        }
    private func saveVibrationAndSubmitExperience(slider1Value: Double, slider2Value: Double) {
        guard let feedbackType = currentFeedbackType, let idVibration = vibrationString[feedbackType] else {
            print("ERREUR : Aucun type de vibration sélectionné avant l'envoi")
            return
        }

        print("✅ Enregistrement en BDD - Vibration ID : \(idVibration), Test : \(42 - validateCount + 1)/42")
        submitExperience(vibrationId: idVibration, slider1Value: slider1Value, slider2Value: slider2Value)
    }

    private func submitExperience(vibrationId: Int, slider1Value: Double, slider2Value: Double) {
        guard let userId = currentUserId, let phoneId = currentPhoneId else {
            print("ERREUR : Aucun utilisateur ou téléphone sélectionné")
            return
        }

        let experience = Experience(
            id: nil,
            agreabilite: Float(slider1Value),
            intensite: Float(slider2Value),
            impression: "",
            user: "\(APIService.shared.baseURL)users/\(userId)",
            telephone: "\(APIService.shared.baseURL)telephones/\(phoneId)",
            vibration: "\(APIService.shared.baseURL)vibrations/\(vibrationId)",
            nombre_de_fois: feedbackPlayCount
        )

        viewModel.createExperience(experience: experience)
        print("✅ Expérience soumise : \(experience)")
    }

    private func resetStateForNextVibrationOrTableau() {
        slider1Value = 0.0
        slider2Value = 5.0
        isFirstButtonPressed = false
        feedbackPlayCount = 0
        currentFeedbackType = nil
        showNextTestView = false
        showThankYouView = false
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView(userId: 1, phoneId: 1)
    }
}

        
        
        

       

        
    








