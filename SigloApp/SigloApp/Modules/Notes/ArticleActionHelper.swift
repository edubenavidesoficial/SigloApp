import Foundation
import SwiftUI

class ArticleActionHelper: ObservableObject {
    @Published var articleViewModel: ArticleViewModel
    @Published var showShareSheet: Bool = false
    @Published var shareContent: [Any] = []

    init(articleViewModel: ArticleViewModel) {
        self.articleViewModel = articleViewModel
    }

    // MARK: - Compartir nota
    func compartirNota(_ nota: Nota) {
        print("Compartir: \(nota.titulo)")

        // Crear contenido para compartir
        let texto = "\(nota.titulo)\n\(nota.localizador)"
        let imagenURL = nota.fotos.first?.url_foto ?? "ejemplo"
        self.shareContent = [texto, imagenURL] // texto + imagen

        // Mostrar el share sheet
        DispatchQueue.main.async {
            self.showShareSheet = true
        }
    }

    // MARK: - Guardar nota
    func guardarNota(_ nota: Nota) {
        print("Guardando nota: \(nota.titulo)")

        // Tomar la primera foto disponible como imagen principal
        let imagenURL = nota.fotos.first?.url_foto ?? "ejemplo"

        let savedArticle = SavedArticle(
            category: nota.localizador,
            title: nota.titulo,
            author: nota.autor ?? "",
            location: nota.ciudad ?? "",
            time: nota.fecha_formato ?? "",
            imageName: imagenURL,
            description: nota.fotos.map { $0.pie_foto ?? "" }.joined(separator: "\n")
        )

        // Guardar en el ViewModel compartido
        articleViewModel.saveArticle(savedArticle)
        articleViewModel.selectedTab = .noticias
    }
}
