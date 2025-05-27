import SwiftUI

struct SearchFrontView: View {
    @StateObject private var viewModel = SearchFrontViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.articulos) { section in
                Text(section.titulo)
                    .font(.headline)
                    .padding(.vertical, 8)
            }
            .navigationTitle("Menú de Búsqueda")
            .onAppear {
                viewModel.cargarMenuBusqueda(query: "") // Asegúrate de que este parámetro sea correcto
            }
        }
    }
}
