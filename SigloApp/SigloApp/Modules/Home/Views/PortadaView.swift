import SwiftUI

struct PortadaView: View {
    @StateObject private var viewModel = PortadaViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if let error = viewModel.errorMessage {
                    VStack {
                        Spacer()
                        Text("❌ Error al cargar la portada")
                            .font(.headline)
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                        Button("Reintentar") {
                            viewModel.obtenerPortada()
                        }
                        .padding()
                        Spacer()
                    }
                } else if viewModel.secciones.isEmpty {
                    VStack {
                        Spacer()
                        ProgressView("Cargando portada...")
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(viewModel.secciones) { seccion in
                            Section(header: Text(seccion.seccion)) {
                                ForEach(seccion.notas) { nota in
                                    NavigationLink(value: nota) {
                                        VStack(alignment: .leading) {
                                            Text(nota.titulo)
                                                .font(.headline)
                                            if let balazo = nota.balazo {
                                                Text(balazo)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .navigationDestination(for: Nota.self) { nota in
                        NotaDetalleView(nota: nota)
                    }
                }
            }
            .onAppear {
                viewModel.obtenerPortada()
            }
            .navigationTitle("Portada")
        }
    }
}
