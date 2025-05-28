import SwiftUI

struct SearchFrontView: View {
    @StateObject private var viewModel = SearchFrontViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView() // Puedes mostrar un indicador de carga
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    List {
                        // Asumo que viewModel.articulos es [Categoria] o similar
                        ForEach(viewModel.articulos) { seccion in
                            Section(header: Text(seccion.titulo).font(.headline)) {
                                // Aquí iteramos en seccion.contenido (que debe ser [Contenido])
                                ForEach(seccion.contenido) { contenido in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(contenido.titulo)
                                            .font(.subheadline)
                                        if let balazo = contenido.balazo {
                                            Text(balazo)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                    }
                    .listStyle(GroupedListStyle()) // Opcional: mejora apariencia
                }
            }
            .navigationTitle("Menú de Búsqueda")
            .onAppear {
                viewModel.cargarMenuBusqueda(query: "")
            }
        }
    }
}
