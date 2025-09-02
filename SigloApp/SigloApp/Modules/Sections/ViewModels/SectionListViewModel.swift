import Foundation

class SectionListViewModel: ObservableObject {
    @Published var secciones: [SectionPayload] = []
    @Published var selectedPayload: SectionPayload?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchSecciones() {
        isLoading = true
        SectionsService.shared.obtenerSecciones { result in
            self.isLoading = false
            switch result {
            case .success(let secciones):
                self.secciones = secciones
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func fetchSeccion(id: Int) {
        isLoading = true
        SectionService.shared.obtenerContenidoDeSeccion(idSeccion: id) { result in
            self.isLoading = false
            switch result {
            case .success(let payload):
                self.selectedPayload = payload
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}

