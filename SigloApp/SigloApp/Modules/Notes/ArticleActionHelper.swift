import Foundation
import SwiftUI

class ArticleActionHelper: ObservableObject {  // Conforma al protocolo ObservableObject
    @Published var articleViewModel: ArticleViewModel  // Si quieres que algo sea observado, usa @Published

    init(articleViewModel: ArticleViewModel) {
        self.articleViewModel = articleViewModel
    }

    func compartirNota(_ nota: Nota) {
        print("Compartir: \(nota.titulo)")
        // Agrega lógica para compartir la nota, por ejemplo, usando un ActivityViewController
    }

    func guardarNota(_ nota: Nota) {
        print("Guardando nota: \(nota.titulo)")

        let savedArticle = SavedArticle(
            category: "Nacional",
            title: nota.titulo,
            author: nota.autor,
            location: "Desconocido",
            time: "Hace 1h",
            imageName: "ejemplo",
            description: nil
        )

        // Guardamos el artículo usando el articleViewModel
      articleViewModel.saveArticle(savedArticle)
    }
}
