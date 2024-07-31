import SwiftUI

struct NextTestView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Chargement ")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
            
            Text("du test suivant")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
            Spacer()
            
            // Ajouter l'image ici
            Image("logo-mira-mobile")
                .resizable()
                .scaledToFit()
                .frame(height: 100) 
                .padding(.bottom, 150)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .ignoresSafeArea()
    }
}

struct NextTestView_Previews: PreviewProvider {
    static var previews: some View {
        NextTestView()
    }
}
