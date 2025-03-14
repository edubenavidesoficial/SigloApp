// ArticleViewModel.swift
// SigloApp

import Foundation

enum TabType: String, CaseIterable {
    case noticias = "NOTICIAS"
    case sigloTV = "SIGLO TV"
    case clasificados = "CLASIFICADOS"
}

class ArticleViewModel: ObservableObject {
    @Published var selectedTab: TabType = .noticias

    var noticias: [SavedArticle] = [
        SavedArticle(
            category: "Nacional",
            title: "Título noticia",
            author: "Redacción",
            location: "México",
            time: "Hace 1h",
            imageName: "ejemplo1",
            description: nil
        )
        // Puedes agregar más noticias...
    ]

    var sigloTV: [SavedArticle] = [
        SavedArticle(
            category: "Video",
            title: "Noticia en video",
            author: "SigloTV",
            location: "Torreón",
            time: "Hace 2h",
            imageName: "ejemplo2",
            description: "Resumen del video o contenido importante."
        )
        // Puedes agregar más videos...
    ]

    var clasificados: [SavedArticle] = [
        SavedArticle(
            category: "Empleo",
            title: "Se solicita técnico",
            author: "Clasificados",
            location: "Saltillo",
            time: "Hace 3h",
            imageName: "ejemplo3",
            description: nil
        )
        // Puedes agregar más clasificados...
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
}
