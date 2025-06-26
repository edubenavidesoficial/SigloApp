import SwiftUI

struct SectionDetailView: View {
    let payload: SectionPayload  // Sección inicial
    @State private var contenido: SectionPayload?
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Cargando contenido...")
            } else if let contenido = contenido {
                Text("Sección: \(contenido.nombre)")
                Text("Tipo: \(contenido.tipo ?? "N/A")")
                if let notas = contenido.notas {
                    List(notas) { nota in
                        Text(nota.titulo)
                    }
                }
            } else if let errorMessage = errorMessage {
                Text("⚠️ \(errorMessage)")
                    .foregroundColor(.red)
            }
        }
        .navigationTitle(payload.nombre)
        .onAppear {
            fetchContenido()
        }
    }

    private func fetchContenido() {
        SectionService.shared.obtenerContenidoDeSeccion(idSeccion: payload.sectionId) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let detalle):
                    self.contenido = detalle
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
