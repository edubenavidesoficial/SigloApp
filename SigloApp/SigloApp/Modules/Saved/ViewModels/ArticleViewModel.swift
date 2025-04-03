import Foundation

enum TabType: String, CaseIterable {
    case noticias = "NOTICIAS"
    case sigloTV = "SIGLO TV"
    case clasificados = "CLASIFICADOS"
}

class ArticleViewModel: ObservableObject {
    @Published var selectedTab: TabType = .noticias
    @Published var savedArticles: [SavedArticle] = [] // Lista de artículos guardados
    @Published var noticias: [SavedArticle] = [] // Lista de noticias, vacía al inicio

    var sigloTV: [SavedArticle] = []
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
    
    func saveArticle(_ article: SavedArticle) {
        // Evitar duplicados en savedArticles
        if !savedArticles.contains(where: { $0.title == article.title }) {
            // Agregar artículo a la lista de guardados
            savedArticles.append(article)
            
            // Crear una nueva instancia de SavedArticle similar a 'notaGuardada'
            let notaGuardada = SavedArticle(
                category: "Sin datos ahora",
                title: "\(article.title)",
                author: "\(article.author)",
                location: "\(article.location)",
                time: "Hace 2h",
                imageName: "\(article.imageName)",
                description: "Resumen del video o contenido importante."
            )
            
            // Actualizar noticias dinámicamente en el hilo principal
            DispatchQueue.main.async {
                self.noticias.append(notaGuardada) // Agregar el artículo modificado a noticias
                print("Artículo guardado: \(notaGuardada.title)")
                print("Total de noticias: \(self.noticias.count)")
            }

            // Debug para ver si se está actualizando noticias
            print("Artículo guardado: \(article.title)")
            print("Total de artículos guardados: \(savedArticles.count)")
            print("Total de noticias actualizadas: \(noticias.count)")
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
            return sigloTV
        case .clasificados:
            return clasificados
        }
    }
}
