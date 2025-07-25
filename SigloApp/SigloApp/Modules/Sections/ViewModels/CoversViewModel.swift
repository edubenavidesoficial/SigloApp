import SwiftUI

final class CoversViewModel: ObservableObject {
    @Published var notas: [Nota] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func cargarPortada() {
        isLoading = true
        errorMessage = nil

        CoversService.shared.obtenerPortadas { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let notas):
                self.notas = notas
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
