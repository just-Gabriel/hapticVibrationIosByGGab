import SwiftUI
import Combine

struct FormulaireView: View {
    @StateObject private var viewModel = UserViewModel()
    @State private var age: String = ""
    @State private var sexe: String = ""
    @State private var mainDominante: String = ""
    @State private var password: String = ""
    @State private var marque: String = ""
    @State private var modele: String = ""
    @State private var versionLogiciel: String = ""
    @State private var numeroModele: String = ""
    @State private var showAlert = false
    @State private var errorMessage: String = ""
    @State private var navigateToTestView = false

    let sexes = ["Homme", "Femme"]
    let mainsDominantes = ["Droite", "Gauche"]
    let marques = ["iOS", "Android"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Âge")) {
                    TextField("Entrez votre âge", text: $age)
                        .keyboardType(.default)
                }

                Section(header: Text("Sexe")) {
                    Picker("Sélectionnez votre sexe", selection: $sexe) {
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

                Section(header: Text("Systeme d'exploitation")) {
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

                .navigationDestination(isPresented: $navigateToTestView) {
                    TestView()
                }
            }
            .navigationTitle("Utilisateur")
            .onAppear {
                viewModel.fetchUsers()
                viewModel.fetchTelephones()
                viewModel.fetchVibrations() // Ajouter cette ligne
            }
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
        guard let userAge = Int(age), !sexe.isEmpty, !mainDominante.isEmpty, !password.isEmpty, !marque.isEmpty, !modele.isEmpty, let version = Double(versionLogiciel.replacingOccurrences(of: ".", with: "")), !version.isNaN, !numeroModele.isEmpty else {
            errorMessage = "Veuillez remplir tous les champs correctement."
            print("Validation échouée: age=\(age), sexe=\(sexe), mainDominante=\(mainDominante), password=\(password), marque=\(marque), modele=\(modele), versionLogiciel=\(versionLogiciel), numeroModele=\(numeroModele)")
            return
        }

        // Reset error message
        errorMessage = ""

        // Création de l'utilisateur
        let user = User(id: nil, age: userAge, sexe: sexe, mainDominante: mainDominante, password: password)
        viewModel.createUser(user: user)
        print("Utilisateur créé avec succès: \(user)")

        // Création du téléphone
        let telephone = Telephone(id: nil, marque: marque, modele: modele, versionLogiciel: version, numeroModele: numeroModele)
        viewModel.createTelephone(telephone: telephone)
        print("Téléphone créé avec succès: \(telephone)")

        // Déclencher la navigation vers TestView
        navigateToTestView = true
    }
}

struct FormulaireView_Previews: PreviewProvider {
    static var previews: some View {
        FormulaireView()
    }
}

