import Foundation

// Definición de las pestañas en la app
enum TabType: String, CaseIterable {
    case noticias = "NOTICIAS"
    case sigloTV = "SIGLO TV"
    case clasificados = "CLASIFICADOS"
}

// ViewModel que gestiona los artículos
class ArticleViewModel: ObservableObject {
    @Published var selectedTab: TabType = .noticias
    @Published var savedArticles: [SavedArticle] = [] // Lista de artículos guardados
    
    // Agregar un artículo a la lista de guardados
    func saveArticle(_ article: SavedArticle) {
        savedArticles.append(article)
        print("Artículo guardado: \(article.title)")
        print("Total de artículos guardados: \(savedArticles.count)")
    }
    // Datos predefinidos para noticias
    var noticias: [SavedArticle] = [
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
    
    // Datos predefinidos para SIGLO TV
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

    // Datos predefinidos para CLASIFICADOS
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

    // Filtrar los artículos según la pestaña seleccionada
    func articlesForCurrentTab() -> [SavedArticle] {
        switch selectedTab {
        case .noticias:
            print("Artículos en noticias: \(savedArticles.count)")
            return savedArticles
        case .sigloTV:
            print("Artículos en sigloTV: \(sigloTV.count)")
            return sigloTV
        case .clasificados:
            print("Artículos en clasificados: \(clasificados.count)")
            return clasificados
        }
    }
}
