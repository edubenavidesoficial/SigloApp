import Foundation

enum TabType: String, CaseIterable {
    case noticias = "NOTICIAS"
    case sigloTV = "SIGLO TV"
    case clasificados = "CLASIFICADOS"
}

class ArticleViewModel: ObservableObject {
    @Published var selectedTab: TabType = .noticias
    @Published var savedArticles: [SavedArticle] = [] { // Lista de artículos guardados con persistencia
        didSet { saveToUserDefaults() }
    }
    @Published var noticias: [SavedArticle] = [] // Lista de noticias
    @Published var sigloTV: [SavedArticle] = [] // Lista Siglo TV
    @Published var clasificados: [SavedArticle] = [] // Lista de clasificados

    init() {
        loadFromUserDefaults() // Cargar artículos guardados al iniciar
    }

    func saveArticle(_ article: SavedArticle) {
        // Evitar duplicados en savedArticles
        if !savedArticles.contains(where: { $0.title == article.title }) {
            savedArticles.append(article)

            // Asignar artículo a la lista correcta según su categoría
            switch article.category {
            case "SIGLO TV":
                sigloTV.append(article)
            case "CLASIFICADOS":
                clasificados.append(article)
            default:
                noticias.append(article)
            }

            print("Artículo guardado: \(article.title)")
            print("Total de noticias: \(noticias.count)")
            print("Total de Siglo TV: \(sigloTV.count)")
            print("Total de clasificados: \(clasificados.count)")
            print("Total de artículos guardados: \(savedArticles.count)")
        } else {
            print("El artículo ya está guardado.")
        }
    }

    // Método para obtener los artículos de la pestaña seleccionada
    func articlesForCurrentTab() -> [SavedArticle] {
        switch selectedTab {
        case .noticias:
            print("🟢 Devolviendo \(noticias.count) noticias")
            return noticias
        case .sigloTV:
            print("🟢 Devolviendo \(sigloTV.count) Siglo TV")
            return sigloTV
        case .clasificados:
            print("🟢 Devolviendo \(clasificados.count) clasificados")
            return clasificados
        }
    }

    // MARK: - Persistencia con UserDefaults
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(savedArticles) {
            UserDefaults.standard.set(encoded, forKey: "savedArticles")
        }
    }

    private func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: "savedArticles"),
           let decoded = try? JSONDecoder().decode([SavedArticle].self, from: data) {
            self.savedArticles = decoded
            // Reasignar a pestañas según categoría
            noticias = decoded.filter { $0.category != "SIGLO TV" && $0.category != "CLASIFICADOS" }
            sigloTV = decoded.filter { $0.category == "SIGLO TV" }
            clasificados = decoded.filter { $0.category == "CLASIFICADOS" }
        }
    }
}
