//
//  RealTestStartView.swift
//  ProjetApi
//
//  Created by Ortega Gabriel on 26/07/2024.
//

import SwiftUI

struct RealTestStartView: View {
    @State private var navigateToRealTest = false
    var body: some View {
        VStack {
            Text("Le vrai test commence")
                .font(.largeTitle)
                .padding(50)
           
            
            Button(action: {
                navigateToRealTest = true
            }) {
                Text("Commencer")
                    .font(.title)
                    .padding()
                    .background(Color(hex: "#019AAF"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .fullScreenCover(isPresented: $navigateToRealTest) {
            TestView()
        }
        }
    }


struct RealTestStartView_Previews: PreviewProvider {
    static var previews: some View {
        RealTestStartView()
    }
}
