import Foundation
import SwiftUI

class ArticleActionHelper: ObservableObject {
    @Published var articleViewModel: ArticleViewModel
    @Published var showShareSheet: Bool = false
    @Published var shareContent: [Any] = []

    init(articleViewModel: ArticleViewModel) {
        self.articleViewModel = articleViewModel
    }

    func compartirNota(_ nota: Nota) {
        print("Compartir: \(nota.titulo)")
        let texto = "\(nota.titulo)\n\(nota.localizador)"
        self.shareContent = [texto]
        
        DispatchQueue.main.async {
            self.showShareSheet = true
        }
    }


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
            imageName: imagenURL, // aquí va la URL real
            description: nota.fotos.map { $0.pie_foto ?? "" }.joined(separator: "\n")
        )

        articleViewModel.saveArticle(savedArticle)
        articleViewModel.selectedTab = .noticias
    }
}
