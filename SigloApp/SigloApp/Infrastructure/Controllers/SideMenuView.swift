import SwiftUI

struct SideMenuView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // Imagen superior (Ejemplo)
                Image("ejemplo")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .clipped()
                    .padding(.top, 10)

                // Logo de "El Siglo"
                Image("titulo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                    .padding(.horizontal)

                // Lista de opciones
                List {
                    menuItem(title: "La Laguna", icon: "sun.max")
                    menuItem(title: "Contenido Patrocinado", icon: "sportscourt")
                    menuItem(title: "Foquitos", icon: "face.smiling")
                    menuItem(title: "Economía", icon: "dollarsign.square")
                    menuItem(title: "México, EUA y Mundo", icon: "flag")
                    menuItem(title: "El Mundo", icon: "globe")
                    menuItem(title: "Entretenimiento", icon: "theatermasks")
                    menuItem(title: "Editorial", icon: "book.closed")
                    menuItem(title: "Laguna Shop", icon: "cart")
                    menuItem(title: "Clasificados", icon: "doc.text")
                    menuItem(title: "Esquelas", icon: "person.text.rectangle")
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
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity)
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.vertical)
            .frame(maxHeight: .infinity)
            .background(Color.gray.opacity(0.2))
        }
    }

    // Función para crear cada elemento del menú
    func menuItem(title: String, icon: String) -> some View {
        NavigationLink(destination: NotesView(title: title)) {
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
                .cornerRadius(20)
                .padding(.bottom, 5)
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
