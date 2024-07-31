//
//  GuideView.swift
//  ProjetiPhone12
//
//  Created by Ortega Gabriel on 05/06/2024.
//

import SwiftUI

struct GuideView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Mode d'emploi")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            Group {
                Text("1. Appuyer sur le bouton pour jouer une vibration.")
                    .font(.headline)
                    .padding(.bottom, 10)
                
                Text("2. Régler le curseur d'agréabilité.")
                    .font(.headline)
                    .padding(.bottom, 10)
                
                Text("3. Régler le curseur d'intensité.")
                    .font(.headline)
                    .padding(.bottom, 10)
                
                Text("4. Choisir son impression dans le menu déroulant.")
                    .font(.headline)
                    .padding(.bottom, 10)
                
                Text("5. Appuyer sur le bouton valider pour enregistrer le test.")
                    .font(.headline)
                    .padding(.bottom, 10)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    GuideView()
}
