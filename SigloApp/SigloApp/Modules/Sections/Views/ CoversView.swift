import SwiftUI

struct CoversView: View {
    @State private var seccionesCount: Int = 0
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            if let error = errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            } else {
                Text("Secciones cargadas: \(seccionesCount)")
            }
            
            Button("Cargar Portada") {
                cargarPortada()
            }
        }
        .padding()
    }

    func cargarPortada() {
        CoversService.shared.obtenerPortadas { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let secciones):
                    seccionesCount = secciones.count
                    errorMessage = nil
                case .failure(let error):
                    errorMessage = error.localizedDescription
                    seccionesCount = 0
                }
            }
        }
    }
}
