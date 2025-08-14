import SwiftUI

class PrintViewModel: ObservableObject {
    @Published var isNewspaperLoaded = false
    @Published var isLoading: Bool = false
    @Published var selectedTab: TabTypetwo = .hemeroteca
    @Published var hemeroteca: [PrintModel] = []
    @Published var suplementos: [SuplementsModel] = []
    @Published var errorMessage: String?
    
    private let printService = PrintService.shared

    func fetchNewspaper() {
        guard !isNewspaperLoaded && !isLoading else { return }

        isLoading = true
        errorMessage = nil

        printService.obtenerPortada { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false

                switch result {
                case .success(let payloads):
                    // Verificamos que haya al menos un payload
                    guard let firstPayload = payloads.first else {
                        self.isNewspaperLoaded = false
                        return
                    }

                    // Mapear portadas a PrintModel
                    self.hemeroteca = firstPayload.portadas.map { portada in
                        PrintModel(
                            title: portada.titulo,
                            imageName: portada.cover,
                            date: firstPayload.fecha ?? "",
                            paginas: firstPayload.paginas
                        )
                    }

                    self.isNewspaperLoaded = true

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isNewspaperLoaded = false
                }
            }
        }
    }

    func printArticlesForCurrentTab() -> [PrintModel] {
        switch selectedTab {
        case .hemeroteca:
            return hemeroteca
        default:
            return []
        }
    }
}
