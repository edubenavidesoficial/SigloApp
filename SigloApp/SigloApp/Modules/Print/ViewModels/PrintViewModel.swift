import SwiftUI

// Tu enum de pestañas
enum TabTypetwo: String, CaseIterable, Identifiable {
    case hemeroteca = "HEMEROTECA EL SIGLO DE TORREÓN"
    case suplementos = "SUPLEMENTOS"
    case descargas = "MIS DESCARGAS"

    var id: String { rawValue }
}

// ViewModel que maneja estado y datos
class PrintViewModel: ObservableObject {
    @Published var isNewspaperLoaded = false
    @Published var selectedTab: TabTypetwo = .hemeroteca
    @Published var hemeroteca: [PrintModel] = []
    @Published var suplementos: [SuplementsModel] = []
    @Published var errorMessage: String?

    private let printService = PrintService.shared

    func fetchNewspaper() {
        guard !isNewspaperLoaded else { return }

        printService.obtenerPortada { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let payloads):
                    self.hemeroteca = payloads.first?.portadas.map { portada in
                        PrintModel(
                            title: portada.titulo,
                            imageName: portada.cover,
                            date: payloads.first?.fecha ?? "Desconocido"
                        )
                    } ?? []
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
