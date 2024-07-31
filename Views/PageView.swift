import SwiftUI

struct PageView: View {
    @State var showMenu = false

    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        self.showMenu = false
                    }
                }
            }

        return GeometryReader { geometry in
            ZStack(alignment: .leading) {   
                VStack {
                    MainView(showMenu: self.$showMenu)
                        .frame(width: geometry.size.width, height: geometry.size.height - 100)
                        .offset(x: self.showMenu ? geometry.size.width / 2 : 0)
                        .disabled(self.showMenu ? true : false)

                    BottomImagesView()
                        .frame(width: geometry.size.width, height: 100)
                        .background(Color.gray.opacity(0.2))
                }

                if self.showMenu {
                    PageMenuView()
                        .frame(width: geometry.size.width / 2)
                        .transition(.move(edge: .leading))
                }
            }
            .gesture(drag)
            .navigationBarTitle("Menu", displayMode: .inline)
            .navigationBarItems(leading: (
                Button(action: {
                    withAnimation {
                        self.showMenu.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .imageScale(.large)
                }
            ))
            .navigationBarBackButtonHidden(true)
            .onAppear {
                self.showMenu = false
            }
        }
    }
}

struct MainView: View {
    @Binding var showMenu: Bool

    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            Text("Bienvenue")
                .font(.title)
            Spacer()
            Text("Notre application vise à offrir une expérience interactive et intuitive. En posant simplement leur doigt sur l'écran, les utilisateurs ressentent une vibration qui simule une connexion tactile. Nous proposons un choix de réactions permettant de sélectionner leur ressenti à un moment précis.")
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
            
            NavigationLink(destination: FormulaireView()) {
                Text("Commencer")
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color(hex: "#A00000"))
                    .cornerRadius(10)
            }
            .padding(.bottom, 0)
            
            Spacer().frame(height: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .padding(.bottom, 35)
    }
}

struct BottomImagesView: View {
    var body: some View {
        HStack {
            Image("logo-aflokkat")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width / 2, height: 100)
                .padding(.leading, -40)

            VStack {
                Spacer()
                Image("logo-mira-mobile")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width / 3, height: 100)
                    .padding(.leading, -10)
            }
        }
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PageView()
                .navigationBarBackButtonHidden(true)
        }
    }
}
