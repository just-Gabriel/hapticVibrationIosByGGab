// ContentView.swift
// ProjetiPhone12
//
// Created by Ortega Gabriel on 05/06/2024.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image("back-aflokkat")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .padding(.bottom, 20)

                Text("Application mobile")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.top, -10)

                Spacer()

                NavigationLink(destination: PageView().navigationBarBackButtonHidden(true)) {
                    Text("Entrer")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(hex: "#A00000"))
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)

                Text("Feel the emotions with touch")
                    .padding(.top, 120)

                Spacer()
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
