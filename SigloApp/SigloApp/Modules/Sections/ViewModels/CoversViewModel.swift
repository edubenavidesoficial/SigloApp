import SwiftUI

final class CoversViewModel: ObservableObject {
    @Published var notas: [Noticia] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func cargarPortada() {
        isLoading = true
        errorMessage = nil

        CoversService.shared.obtenerPortadaMinutos { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let payload):
                    self.notas = payload.notas ?? []
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}


