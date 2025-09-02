import SwiftUI

// ViewModel para los clasificados
class ClassfiedDdsViewModel: ObservableObject {
    @Published var isNewspaperLoaded = false
    @Published var selectedTab: TabClassifieds = .avisos
    @Published var avisos: [ClassifiedsModel] = []
    @Published var desplegados: [ClassifiedsModel] = []
    @Published var esquelas: [ClassifiedsModel] = []
    @Published var anunciate: [ClassifiedsModel] = []
    @Published var selectedCategory: String? = nil
    @Published var errorMessage: String?

    private let anunciosService = AnunciosService.shared

    // Cargar secciones generales — ahora con parámetro tipo
    func fetchClassifiedCategories(tipo: String) {
        guard !isNewspaperLoaded else { return }

        anunciosService.obtenerAnuncios(tipo: tipo) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let payloads):
                    self.avisos = payloads.map { section in
                        ClassifiedsModel(
                            id: section.seccion, // ya es String en el JSON
                            seccion_nombre: section.nombreSeccion,
                            anuncio: "",
                            title: section.nombreSeccion
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

    // Cargar artículos por tipo: avisos, desplegados, esquelas, etc.
    func loadAds(tipo: String = "desplegados") {
        anunciosService.obtenerAnuncios(tipo: tipo) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let secciones):
                    let ads = secciones.flatMap { seccion in
                        seccion.items.map { item in
                            ClassifiedsModel(
                                id: String(item.id), // convierte Int a String
                                seccion_nombre: seccion.nombreSeccion,
                                anuncio: item.titulo,
                                title: item.titulo
                            )
                        }
                    }
                    switch tipo {
                    case "avisos": self.avisos = ads
                    case "desplegados": self.desplegados = ads
                    case "esquelas": self.esquelas = ads
                    case "anunciate": self.anunciate = ads
                    default: break
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // Obtener artículos según tab actual y filtro de categoría
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

        if let selectedCategory = selectedCategory {
            articles = articles.filter { $0.title == selectedCategory }
        }

        return articles
    }
}
