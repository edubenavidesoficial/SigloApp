import SwiftUI

struct HomeHeaderView: View {
    @State private var showMenu = false  // Controla la visibilidad del menú

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                // Botón de menú
                Button(action: {
                    showMenu.toggle() // Abrir el menú lateral
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.title2)
                        .foregroundColor(.black)
                }

                Spacer()

                // Logo de "El Siglo"
                Image("titulo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)

                Spacer()

                // Botón de búsqueda
                Button(action: {
                    // Acción de búsqueda
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)
            .padding(.top, 15)

            Divider()
                .frame(height: 0.5)
                .background(Color.black)
        }
        .sheet(isPresented: $showMenu) {
            SideMenuView()
        }
        
    }
}

