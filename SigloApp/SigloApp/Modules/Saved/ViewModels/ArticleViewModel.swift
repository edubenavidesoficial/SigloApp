import Foundation

enum TabType: String, CaseIterable {
    case noticias = "NOTICIAS"
    case sigloTV = "SIGLO TV"
    case clasificados = "CLASIFICADOS"
}

class ArticleViewModel: ObservableObject {
    @Published var selectedTab: TabType = .noticias
    @Published var savedArticles: [SavedArticle] = [] // Lista de artículos guardados
    @Published var noticias: [SavedArticle] = [] // Lista de noticias
    @Published var sigloTV: [SavedArticle] = [] // Lista Siglo TV
    @Published var clasificados: [SavedArticle] = []
    
    func saveArticle(_ article: SavedArticle) {
        // Evitar duplicados en savedArticles
        if !savedArticles.contains(where: { $0.title == article.title }) {
            savedArticles.append(article)
            
            // Asignar artículo a la lista correcta según su categoría
            DispatchQueue.main.async {
                switch article.category {
                case "SIGLO TV":
                    self.sigloTV.append(article)
                case "CLASIFICADOS":
                    self.clasificados.append(article)
                default:
                    self.noticias.append(article)
                }
                
                print("Artículo guardado: \(article.title)")
                print("Total de noticias: \(self.noticias.count)")
                print("Total de Siglo TV: \(self.sigloTV.count)")
                print("Total de clasificados: \(self.clasificados.count)")
                print("Total de artículos guardados: \(self.savedArticles.count)")
            }
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
}
