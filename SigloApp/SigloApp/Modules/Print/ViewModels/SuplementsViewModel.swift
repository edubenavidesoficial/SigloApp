import Foundation
import SwiftUI

class SuplementsViewModel: ObservableObject {
    @Published var selectedTab: TabTypetwo = .suplementos
    @Published var suplementos: [SuplementsModel] = []
    @Published var errorMessage: String?

    private let suplementsService = SuplementsService.shared

    init() {
        fetchSuplementos()
    }

    /// Función para obtener los suplementos desde el servicio
    func fetchSuplementos() {
        suplementsService.obtenerSuplementos { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let payloads):
                    let suplementos = payloads.map { payload in
                        SuplementsModel(
                            id: payload.id,
                            ruta:payload.ruta,
                            title: payload.titulo,
                            imageName: payload.portada,
                            date: payload.fecha
                        )
                    }
                    print("✅ Suplementos obtenidos: \(suplementos.count)")
                    self?.suplementos = suplementos
                case .failure(let error):
                    print("❌ Error al obtener datos suplementos: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func suplementsFiltered(by ruta: String) -> [SuplementsModel] {
        return suplementos.filter { $0.title.localizedCaseInsensitiveContains(ruta) }
    }

    func suplementsForCurrentTab() -> [SuplementsModel] {
        switch selectedTab {
        case .suplementos, .descargas:
            return suplementos
        default:
            return []
        }
    }
}
