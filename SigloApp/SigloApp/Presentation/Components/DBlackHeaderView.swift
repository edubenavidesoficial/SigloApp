import SwiftUI

struct DBlackHeaderView: View {
    @Binding var selectedOption: MenuOption?
    @Binding var isMenuOpen: Bool
    var isLoggedIn: Bool
    var showBack: Bool = true
    var isInUserView: Bool = false

    var action: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss

    @State private var showLogoutAlert = false
    @State private var isSearchViewPresented = false
    @State private var mostrarSectionsFullscreen = false

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(spacing: 0) {
                HStack {
                    if showBack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .imageScale(.large)
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 1, x: 0.5, y: 0.5)
                        }
                        .padding(.bottom, 8) // <-- agrega espacio debajo de la flecha
                    }

                    Spacer()
                }

                .padding(.horizontal)
                .padding(.top, 15)
                .frame(height: 44)
                .background(Color.black)

                Divider()
                    .frame(height: 0.5)
                    .background(Color.gray)
            }
            .blur(radius: isMenuOpen ? 8 : 0)
            .disabled(isMenuOpen)

            // Fondo oscuro del menú cuando está abierto
            if isMenuOpen {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isMenuOpen = false
                        }
                    }
                    .zIndex(1)
            }
        }
    }
}
