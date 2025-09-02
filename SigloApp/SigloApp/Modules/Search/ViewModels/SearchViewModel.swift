import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchResults: [ArticuloPayload] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    func buscarArticulos(query: String) {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        isLoading = true
        errorMessage = nil

        SearchService.shared.buscarPorTexto(query) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false

            switch result {
            case .success(let articulos):
                self.searchResults = articulos
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
