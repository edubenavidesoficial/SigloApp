import SwiftUI

// Enum para las pestañas del menú clasificados
enum TabClassifieds: String, CaseIterable, Identifiable {
    case avisos = "AVISOS"
    case desplegados = "DESPLEGADOS" 
    case esquelas = "ESQUELAS"
    case anunciate = "ANUNCIATE"

    var id: String { rawValue }
}

class ClassifiedsViewModel: ObservableObject {
    @Published var isNewspaperLoaded = false
    @Published var selectedTab: TabClassifieds = .avisos

    // Aquí usas modelos adecuados para cada sección
    @Published var avisos: [ClassifiedsModel] = []
    @Published var desplegados: [SuplementsModel] = []
    @Published var anunciate: [SuplementsModel] = []

    @Published var errorMessage: String?

    private let classifiedsService = ClassifiedsService.shared

    // Carga las categorías de clasificados (secciones y categorías)
    func fetchClassifiedCategories() {
        guard !isNewspaperLoaded else { return }

        classifiedsService.obtenerCategorias { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let payloads):
                    // payloads es [String: ClassifiedSection]
                    // Mapeamos cada sección a un modelo simple para mostrar
                    self.avisos = payloads.compactMap { key, section in
                        ClassifiedsModel(
                            title: section.nombre,
                            imageName: "", // Si no hay imagen, deja vacío o agrega lógica
                            date: "" // Si no hay fecha, deja vacío o agrega lógica
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
    // Devuelve los anuncios según la pestaña seleccionada
    func classifiedsArticlesForCurrentTab() -> [ClassifiedsModel] {
        switch selectedTab {
        case .avisos:
            return avisos
        case .desplegados:
            // Si quieres devolver desplegados, ajusta aquí
            return []
        case .esquelas:
            // Si quieres devolver esquelas, ajusta aquí
            return []
        case .anunciate:
            // Si quieres devolver anunciate, ajusta aquí
            return []
        }
    }
}
