import Foundation

class PortadaViewModel: ObservableObject {
    @Published var secciones: [SeccionPortada] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    func obtenerPortada() {
        // Marcar como cargando
        isLoading = true
        errorMessage = nil

        PortadaService.shared.obtenerPortada { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let secciones):
                    self.secciones = secciones
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
