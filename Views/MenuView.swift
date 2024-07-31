import SwiftUI

struct PageMenuView: View { // Renommé de MenuView
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: FormulaireView()) {
                Text("Formulaire")
                    .foregroundColor(.white) // Assurez-vous que le texte est blanc
                    .font(.headline)
                    .padding(.top, 30)
            }
            NavigationLink(destination: GuideView()) {
                Text("Guide d'utilisation")
                    .foregroundColor(.white) // Assurez-vous que le texte est blanc
                    .font(.headline)
                    .padding(.top, 30)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#A00000")) // Utilisation de la couleur de fond rouge hexadécimale
        .opacity(0.9)
        .cornerRadius(0)
        .padding(.top, 190)
        .padding(.bottom, 200)
        .edgesIgnoringSafeArea(.all)
    }
}

struct PageMenuView_Previews: PreviewProvider {
    static var previews: some View {
        PageMenuView()
    }
}
