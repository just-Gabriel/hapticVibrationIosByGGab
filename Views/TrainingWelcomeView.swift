//
//  TrainingWelcomeView.swift
//  ProjetApi
//
//  Created by Ortega Gabriel on 26/07/2024.
//
//
//  TrainingWelcomeView.swift
//  ProjetApi
//
//  Created by Ortega Gabriel on 26/07/2024.
//

import SwiftUI

/*struct TrainingWelcomeView: View {
        @State private var navigateToTraining = false
    
    let userId: Int
    let phoneId: Int
    
    
    var body: some View {
        VStack {
            Text("Test d'entraînement")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding()

            Text("Vous allez passer par une série de 5 tests d'entraînement avant de commencer les vrais tests.")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(50)

            Button(action: {
                navigateToTraining = true
            }) {
                Text("Commencer")
                    .font(.title)
                    .padding(20)
                    .background(Color(hex: "#019AAF"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .fullScreenCover(isPresented: $navigateToTraining) {
            TrainingTestView(userId: 1, phoneId: 1)
        }
        .navigationBarHidden(true) 
    }
}

struct TrainingWelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingWelcomeView(userId: userId, phoneId: phoneId)
    }
}*/

import SwiftUI

struct TrainingWelcomeView: View {
    let userId: Int
    let phoneId: Int

    @State private var navigateToTraining = false

    var body: some View {
        VStack {
            Text("Test d'entraînement")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding()

            Text("Vous allez passer par une série de 5 tests d'entraînement avant de commencer les vrais tests.")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(50)

            Button(action: {
                navigateToTraining = true
            }) {
                Text("Commencer")
                    .font(.title)
                    .padding(20)
                    .background(Color(hex: "#019AAF"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .fullScreenCover(isPresented: $navigateToTraining) {
            TrainingTestView(userId: userId, phoneId: phoneId) // ✅ On passe les bonnes valeurs
        }
        .navigationBarHidden(true)
    }
}

struct TrainingWelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingWelcomeView(userId: 1, phoneId: 1) // ✅ Correction ici
    }
}
