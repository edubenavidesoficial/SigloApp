import SwiftUI

struct HeaderView: View {
    @Binding var selectedOption: MenuOption?
    @Binding var isMenuOpen: Bool
    var isLoggedIn: Bool
    var showBack: Bool = true
    var isInUserView: Bool = false

    var action: (() -> Void)? = nil

    @Environment(\.dismiss) var dismiss

    @State private var showLogoutAlert = false
    @State private var isSearchViewPresented = false
    @State private var mostrarSectionsFullscreen = false

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(spacing: 0) {
                HStack {
                    // Botón izquierdo: retroceder o menú
                    Button(action: {
                        if isInUserView {
                             dismiss()
                        } else if selectedOption != nil {
                            dismiss()
                        } else {
                            mostrarSectionsFullscreen = true
                        }
                    }) {
                        Image(systemName: isInUserView ? "chevron.left" : "line.horizontal.3")
                            .imageScale(.large)
                    }

                    Spacer()

                    Image("titulo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)

                    Spacer()

                    // Botón derecho: buscar
                    Button(action: {
                        isSearchViewPresented = true
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
            .blur(radius: isMenuOpen ? 8 : 0)
            .disabled(isMenuOpen)

            if isMenuOpen {
                // Fondo semitransparente para cerrar menú con tap
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isMenuOpen = false
                        }
                    }
                    .zIndex(1)

                // Menú lateral
                SideMenuView(selectedOption: $selectedOption, isMenuOpen: $isMenuOpen)
                    .frame(width: 250)
                    .transition(.move(edge: .leading))
                    .zIndex(2)
            }
        }
        // Presentación fullscreen de SectionsView
        .fullScreenCover(isPresented: $mostrarSectionsFullscreen) {
            SectionsView()
        }
        // Navegación a búsqueda
        .background(
            NavigationLink(
                destination: SearchFrontView(),
                isActive: $isSearchViewPresented,
                label: { EmptyView() }
            )
            .hidden()
        )
    }
}
