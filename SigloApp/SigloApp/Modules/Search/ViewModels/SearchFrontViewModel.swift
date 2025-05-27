import Foundation
import Combine

final class SearchFrontViewModel: ObservableObject {
    @Published var articulos: [ArticuloPayload] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    func cargarMenuBusqueda(query: String) {
        isLoading = true
        errorMessage = nil

        SearchFrontService.shared.optenerMenuBusqueda{ [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false

                switch result {
                case .success(let articulos):
                    self.articulos = articulos
                case .failure(let error):
                    self.errorMessage = "Error al cargar: \(error.localizedDescription)"
                }
            }
        }
    }
}
