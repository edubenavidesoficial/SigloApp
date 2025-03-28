import SwiftUI

struct SideMenuView: View {
    var body: some View {
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
                MenuRow(title: "La Laguna", icon: "sun.max")
                MenuRow(title: "Meta", icon: "sportscourt")
                MenuRow(title: "Rostros", icon: "face.smiling")
                MenuRow(title: "Economía", icon: "dollarsign.square")
                MenuRow(title: "México y EEUU", icon: "flag")
                MenuRow(title: "El Mundo", icon: "globe")
                MenuRow(title: "Espectáculos", icon: "theatermasks")
                MenuRow(title: "Cultura", icon: "book.closed")
                MenuRow(title: "Laguna Shop", icon: "cart")
                MenuRow(title: "Clasificados", icon: "doc.text")
                MenuRow(title: "Esquelas", icon: "person.text.rectangle")
            }
            .listStyle(PlainListStyle())

            Spacer()

            // Botones "Anúnciate" y "Suscríbete"
            VStack {
                Button(action: {
                    print("Anúnciate presionado")
                }) {
                    Text("Anúnciate")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 40)
                        .background(Color.red)
                        .cornerRadius(20)
                        .padding(.bottom, 5)
                }

                Button(action: {
                    print("Suscríbete presionado")
                }) {
                    Text("Suscríbete")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 40)
                        .background(Color.red)
                        .cornerRadius(20)
                }
            }
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity)
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.vertical)
        .frame(maxHeight: .infinity )
        .background(Color.gray.opacity(0.2))
    }
}

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
