//
//  ThankYouView.swift
//  ProjetApi
//
//  Created by Ortega Gabriel on 25/06/2024.
//

import SwiftUI

struct ThankYouView: View {
 @State private var navigateToPageView = false
    var body: some View {
     NavigationView {
      VStack {
       Spacer()
       
       Text("Félicitation, l'expérience est terminée ")
        .font(.subheadline)
        .multilineTextAlignment(.center)
        .padding()
       
       
       
       Text("Merci de votre participation.")
        .font(.headline)
        .multilineTextAlignment(.center)
        .padding()
       
       Spacer()
       NavigationLink {
        // destination view to navigation to
        PageView()
       } label: {
        Text("Menu")
         .font(.title2)
         .foregroundColor(.white)
         .padding()
         .background(Color(hex: "#A00000"))
         .cornerRadius(10)
       }
       
       
       
       Spacer()
       
       Image("back-aflokkat")
        .resizable()
        .scaledToFit()
        .frame(width: 300, height: 150)
      }
      .navigationBarHidden(true)
     }
    }
}

struct ThankYouView_Previews: PreviewProvider {
    static var previews: some View {
        ThankYouView()
    }
}

