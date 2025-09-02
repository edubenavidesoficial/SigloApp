import Combine

final class SuplementsDocViewModel: ObservableObject {
    @Published var suplementos: [SuplementoPayload] = []
    @Published var errorMessage: String?

    func cargarSuplementos() {
        SuplementsDocService.shared.obtenerDocSuplementos { result in
            switch result {
            case .success(let suplementos):
                self.suplementos = suplementos
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
