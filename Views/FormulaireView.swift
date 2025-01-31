import SwiftUI
import Combine

struct FormulaireView: View {
    @StateObject private var viewModel = UserViewModel()
    @State private var age: String = ""
    @State private var sexe: String = ""
    @State private var mainDominante: String = ""
    @State private var password: String = ""
    @State private var paysResidence: String = ""
    @State private var profession: String = ""
    @State private var vibrationTelActive: String = ""
    @State private var vibrationClavierActive: String = ""
    @State private var coqueTel: String = ""
    @State private var niveauInformatique: Int = 0
    @State private var marque: String = ""
    @State private var modele: String = ""
    @State private var versionLogiciel: String = ""
    @State private var numeroModele: String = ""
    @State private var showAlert = false
    @State private var errorMessage: String = ""
    @State private var navigateToTestView = false
    @State private var createdUserId: Int?
    @State private var createdPhoneId: Int?
    
    
    let sexes = ["Homme", "Femme"]
    let mainsDominantes = ["Droite", "Gauche"]
    let ouiNon = ["Oui", "Non"]
    let marques = ["iOS", "Android"]
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Âge")) {
                        TextField("Entrez votre âge", text: $age)
                            .keyboardType(.numberPad)
                            .onSubmit {
                                validateAge()
                            }
                    }
                    
                    Section(header: Text("Genre")) {
                        Picker("Sélectionnez votre genre", selection: $sexe) {
                            ForEach(sexes, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(header: Text("Main Dominante")) {
                        Picker("Sélectionnez votre main dominante", selection: $mainDominante) {
                            ForEach(mainsDominantes, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(header: Text("Identifiant")) {
                        SecureField("Entrez votre identifiant", text: $password)
                            .keyboardType(.default)
                    }
                    
                    Section(header: Text("Pays de résidence")) {
                        TextField("Entrez votre lieu de résidence", text: $paysResidence)
                            .keyboardType(.default)
                    }
                    
                    Section(header: Text("Profession")) {
                        TextField("Entrez votre profession", text: $profession)
                            .keyboardType(.default)
                    }
                    
                    Section(header: Text("Les vibrations de votre téléphone sont-elles activées ?")) {
                        Picker("Vibrations téléphone activées", selection: $vibrationTelActive) {
                            ForEach(ouiNon, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(header: Text("Les vibrations de votre clavier sont-elles activées ?")) {
                        Picker("Vibrations clavier activées", selection: $vibrationClavierActive) {
                            ForEach(ouiNon, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(header: Text("Utilisez-vous une coque pour votre téléphone ?")) {
                        Picker("Utilisez-vous une coque pour votre téléphone", selection: $coqueTel) {
                            ForEach(ouiNon, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(header: Text("Système d'exploitation")) {
                        Picker("Sélectionnez la marque", selection: $marque) {
                            ForEach(marques, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(header: Text("Modèle de votre smartphone")) {
                        TextField("Entrez votre modèle", text: $modele)
                            .keyboardType(.default)
                    }
                    
                    Section(header: Text("Version du logiciel")) {
                        TextField("Entrez la version", text: $versionLogiciel)
                            .keyboardType(.default)
                            .onSubmit {
                                validateVersion(versionLogiciel)
                            }
                    }
                    
                    Section(header: Text("Numéro du modèle")) {
                        TextField("Entrez le numéro du modèle", text: $numeroModele)
                            .keyboardType(.default)
                    }
                    
                    Section(header: Text("Quel est votre niveau en informatique ? (de 0 à 5)")) {
                        Stepper(value: $niveauInformatique, in: 0...5) {
                            Text("Niveau \(niveauInformatique)")
                        }
                    }
                    
                    if !errorMessage.isEmpty {
                        Section {
                            Text(errorMessage)
                                .foregroundColor(.red)
                        }
                    }
                    
                    Section {
                        Button(action: {
                            handleSubmit()
                        }, label: {
                            Text("Passer au test")
                                .frame(maxWidth: .infinity, alignment: .center)
                        })
                    }
                }
                .navigationTitle("Utilisateur")
                .onAppear {
                    subscribeToFetchUsers()
                    subscribeToFetchTelephones()
                    //subscribeToFetchVibrations()
                }
                //.navigationDestination(isPresented: $navigateToTestView) {
                    //TrainingWelcomeView()
                
                /*.navigationDestination(isPresented: $navigateToTestView) {
                    if let userId = createdUserId, let phoneId = createdPhoneId {
                        TestView(userId: userId, phoneId: phoneId)
                    } else {
                        Text("Erreur : ID utilisateur ou téléphone non trouvé")
                    }
                }*/
                
                .navigationDestination(isPresented: $navigateToTestView) {
                    if let userId = createdUserId, let phoneId = createdPhoneId {
                        TrainingWelcomeView(userId: userId, phoneId: phoneId)
                    } else {
                        Text("Erreur : ID utilisateur ou téléphone non trouvé")
                    }
                }

            }
        }
    }
    
    private func subscribeToFetchUsers() {
        viewModel.fetchUsers()
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &viewModel.cancellables)
    }
    
    private func subscribeToFetchTelephones() {
        viewModel.fetchTelephones()
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &viewModel.cancellables)
    }
    
    private func subscribeToFetchVibrations() {
        viewModel.fetchVibrations()
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &viewModel.cancellables)
    }
    
    private func validateAge() {
        if !age.isEmpty && Int(age) == nil {
            age = ""
            errorMessage = "L'âge doit être un nombre valide."
        }
    }
    
    private func validateVersion(_ newValue: String) {
        let versionPattern = "^[0-9]+(\\.[0-9]+)*$"
        let regex = try! NSRegularExpression(pattern: versionPattern)
        let range = NSRange(location: 0, length: newValue.utf16.count)
        if regex.firstMatch(in: newValue, options: [], range: range) != nil {
            versionLogiciel = newValue
        } else {
            versionLogiciel = ""
            errorMessage = "La version du logiciel doit être un format valide (par exemple 00.0.0)."
        }
    }
    
    
    
    
    
    
    
    private func handleSubmit() {
        guard let userAge = Int(age), !sexe.isEmpty, !mainDominante.isEmpty, !password.isEmpty,
              !paysResidence.isEmpty, !profession.isEmpty, !vibrationTelActive.isEmpty,
              !vibrationClavierActive.isEmpty, !coqueTel.isEmpty, !marque.isEmpty,
              !modele.isEmpty, let version = Double(versionLogiciel.replacingOccurrences(of: ".", with: "")),
              !version.isNaN, !numeroModele.isEmpty else {
            errorMessage = "Veuillez remplir tous les champs correctement."
            return
        }

        let user = User(id: nil, age: userAge, sexe: sexe, mainDominante: mainDominante,
                        password: password, paysResidence: paysResidence, profession: profession,
                        vibrationTelActive: vibrationTelActive == "Oui",
                        vibrationClavierActive: vibrationClavierActive == "Oui",
                        coqueTel: coqueTel == "Oui", niveauInformatique: niveauInformatique)

        let telephone = Telephone(id: nil, marque: marque, modele: modele,
                                  versionLogiciel: versionLogiciel, numeroModele: numeroModele)

        // Créer l'utilisateur et récupérer son ID
        viewModel.createUser(user: user)
            .flatMap { createdUser -> AnyPublisher<Telephone, Error> in
                self.createdUserId = createdUser.id
                print("Utilisateur créé avec ID: \(createdUser.id ?? -1)")
                
                
                return self.viewModel.createTelephone(telephone: telephone)
            }
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Erreur lors de la création des données : \(error)")
                    self.errorMessage = "Erreur lors de la création des données."
                }
            }, receiveValue: { createdPhone in
                self.createdPhoneId = createdPhone.id
                print("Téléphone créé avec ID: \(createdPhone.id ?? -1)")

                
                DispatchQueue.main.async {
                    self.navigateToTestView = true
                }
            })
            .store(in: &viewModel.cancellables)
    }


    
    
    
    
    
    struct FormulaireView_Previews: PreviewProvider {
        static var previews: some View {
            FormulaireView()
        }
    }
}
