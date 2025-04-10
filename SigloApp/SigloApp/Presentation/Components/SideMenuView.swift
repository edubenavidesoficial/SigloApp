import SwiftUI
struct SideMenuView: View {
    @Binding var selectedOption: MenuOption?
    @Binding var isMenuOpen: Bool
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // Imagen superior (Ejemplo)
                Image("menu")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .clipped()
                    .padding(.top, 10)

                HStack(spacing: 20) {
                    Spacer() // Para agregar espacio a la izquierda
                    Image("logo.youtube").resizable().frame(width: 20, height: 20)
                    Image("logo.facebook").resizable().frame(width: 20, height: 18)
                    Image("logo.twitter").resizable().frame(width: 20, height: 20)
                    Image("logo.instagram").resizable().frame(width: 20, height: 20)
                    Image("logo.tiktok").resizable().frame(width: 20, height: 20)
                    Spacer() // Para agregar espacio a la derecha
                }
                .padding(.vertical, 5)

                // Lista de opciones
                List {
                    menuItem(option: .laLaguna)
                    menuItem(option: .patrocinado)
                    menuItem(option: .foquitos)
                    menuItem(option: .economia)
                    menuItem(option: .mexico)
                    menuItem(option: .mundo)
                    menuItem(option: .entretenimiento)
                    menuItem(option: .editorial)
                    menuItem(option: .shop)
                    menuItem(option: .clasificados)
                    menuItem(option: .esquelas)
                }
                .listStyle(PlainListStyle())

                Spacer()

                // Botones "Anúnciate" y "Suscríbete"
                VStack {
                    actionButton(title: "Anúnciate") {
                        print("Anúnciate presionado")
                    }

                    actionButton(title: "Suscríbete") {
                        print("Suscríbete presionado")
                    }
                }
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity)
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.vertical)
            .frame(maxHeight: .infinity)
            .background(Color.gray.opacity(0.2))
        }
    }

    // Función para crear cada elemento del menú
    func menuItem(title: String, icon: String, selectedOption: Binding<MenuOption?>) -> some View {
        NavigationLink(destination: NotesView(title: title, selectedOption: selectedOption)) {
            MenuRow(title: title, icon: icon)
        }
    }

    // Función para crear botones reutilizables
    func actionButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 200, height: 40)
                .background(Color.red)
                .padding(.bottom, 5)
        }
    }
    // Función para crear cada elemento del menú
    func menuItem(option: MenuOption) -> some View {
        Button(action: {
            selectedOption = option
            isMenuOpen = false
        }) {
            HStack {
                Text(option.title)
                    .font(.headline)
                Spacer()
                Image(systemName: "arrow.right")
            }
            .padding(.vertical, 5)
        }
    }

}

enum MenuOption: Identifiable {
    case laLaguna, patrocinado, foquitos, economia, mexico, mundo, entretenimiento, editorial, shop, clasificados, esquelas

    var id: String { title }
    
    var title: String {
        switch self {
        case .laLaguna: return "La Laguna"
        case .patrocinado: return "Contenido Patrocinado"
        case .foquitos: return "Foquitos"
        case .economia: return "Economía"
        case .mexico: return "México, EUA y Mundo"
        case .mundo: return "El Mundo"
        case .entretenimiento: return "Entretenimiento"
        case .editorial: return "Editorial"
        case .shop: return "Laguna Shop"
        case .clasificados: return "Clasificados"
        case .esquelas: return "Esquelas"
        }
    }
}


// Vista para cada fila del menú
struct MenuRow: View {
    var title: String
    var icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 25, height: 25)
            Text(title)
                .font(.headline)
            Spacer()
        }
        .padding(.vertical, 5)
    }
}
