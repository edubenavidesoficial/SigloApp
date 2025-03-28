import Foundation

enum TabType: String, CaseIterable {
    case noticias = "NOTICIAS"
    case sigloTV = "SIGLO TV"
    case clasificados = "CLASIFICADOS"
}

class ArticleViewModel: ObservableObject {
    @Published var selectedTab: TabType = .noticias
    @Published var savedArticles: [SavedArticle] = []

    var noticias: [SavedArticle] = [
        // Puedes agregar algunas noticias predeterminadas si lo deseas
    ]

    var sigloTV: [SavedArticle] = [
        SavedArticle(
            category: "Video",
            title: "Noticia en video",
            author: "SigloTV",
            location: "Torreón",
            time: "Hace 2h",
            imageName: "ejemplo",
            description: "Resumen del video o contenido importante."
        )
    ]

    var clasificados: [SavedArticle] = [
        SavedArticle(
            category: "Empleo",
            title: "Se solicita técnico",
            author: "Clasificados",
            location: "Saltillo",
            time: "Hace 3h",
            imageName: "ejemplo",
            description: nil
        )
    ]

    func articlesForCurrentTab() -> [SavedArticle] {
        switch selectedTab {
        case .noticias:
            return noticias
        case .sigloTV:
            return sigloTV
        case .clasificados:
            return clasificados
        }
    }
    // Función para agregar una nota guardada
    func saveArticle(_ article: SavedArticle) {
        savedArticles.append(article)
    }
}
