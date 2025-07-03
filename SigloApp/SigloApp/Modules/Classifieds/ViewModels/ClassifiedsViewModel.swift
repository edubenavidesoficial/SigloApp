import SwiftUI

// Enum para las pestañas del menú clasificados
enum TabClassifieds: String, CaseIterable, Identifiable {
    case avisos = "AVISOS"
    case desplegados = "DESPLEGADOS"
    case esquelas = "ESQUELAS"
    case anunciate = "ANUNCIATE"

    var id: String { rawValue }
}

// ViewModel para los clasificados
class ClassifiedsViewModel: ObservableObject {
    @Published var isNewspaperLoaded = false
    @Published var selectedTab: TabClassifieds = .avisos

    @Published var avisos: [ClassifiedsModel] = []
    @Published var desplegados: [ClassifiedsModel] = []
    @Published var esquelas: [ClassifiedsModel] = []
    @Published var anunciate: [ClassifiedsModel] = []

    @Published var selectedCategory: String? = nil  // <-- Aquí guardamos la categoría seleccionada

    @Published var errorMessage: String?

    private let classifiedsService = ClassifiedsService.shared

    func fetchClassifiedCategories() {
        guard !isNewspaperLoaded else { return }

        classifiedsService.obtenerCategorias { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let payloads):
                    self.avisos = payloads.compactMap { key, section in
                        ClassifiedsModel(
                            id: key,
                            seccion_nombre: section.nombre,
                            anuncio: "",
                            title: section.nombre        
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

    func classifiedsArticlesForCurrentTab() -> [ClassifiedsModel] {
        var articles = [ClassifiedsModel]()

        switch selectedTab {
        case .avisos:
            articles = avisos
        case .desplegados:
            articles = desplegados
        case .esquelas:
            articles = esquelas
        case .anunciate:
            articles = anunciate
        }

        // Filtrar por categoría si se ha seleccionado alguna
        if let selectedCategory = selectedCategory {
            articles = articles.filter { $0.title == selectedCategory }
        }

        return articles
    }
}
