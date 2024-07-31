//
//  RealTestTransitionView.swift
//  ProjetApi
//
//  Created by Ortega Gabriel on 26/07/2024.
//
//
//import SwiftUI
//
//struct RealTestTransitionView: View {
//    @State private var navigateToRealTest = false
//
//    var body: some View {
//        VStack {
//            Text("Le vrai test commence")
//                .font(.largeTitle)
//                .padding()
//
//            Button(action: {
//                navigateToRealTest = true
//            }) {
//                Text("Commencer les vrais tests")
//                    .font(.title)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding()
//        }
//        .fullScreenCover(isPresented: $navigateToRealTest) {
//            TestView()
//        }
//    }
//}
//
//struct RealTestTransitionView_Previews: PreviewProvider {
//    static var previews: some View {
//        RealTestTransitionView()
//    }
//}
