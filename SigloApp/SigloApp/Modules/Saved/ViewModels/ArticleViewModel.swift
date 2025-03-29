import Foundation

enum TabType: String, CaseIterable {
    case noticias = "NOTICIAS"
    case sigloTV = "SIGLO TV"
    case clasificados = "CLASIFICADOS"
}

class ArticleViewModel: ObservableObject {
    @Published var selectedTab: TabType = .noticias
    @Published var savedArticles: [SavedArticle] = []
    
    // Función para agregar una nota guardada
    func saveArticle(_ article: SavedArticle) {
        savedArticles.append(article)
        print("Artículo guardado: \(article.title)")  // Agregar impresión para verificar
        print("Total de artículos guardados: \(savedArticles.count)")  // Verificar la cantidad de artículos guardados
    }


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
            print("Artículos en noticias: \(savedArticles.count)")  // Imprimir cuántos artículos hay en noticias
            return savedArticles
        case .sigloTV:
            print("Artículos en sigloTV: \(sigloTV.count)")  // Imprimir cuántos artículos hay en sigloTV
            return sigloTV
        case .clasificados:
            print("Artículos en clasificados: \(clasificados.count)")  // Imprimir cuántos artículos hay en clasificados
            return clasificados
        }
    }

}


