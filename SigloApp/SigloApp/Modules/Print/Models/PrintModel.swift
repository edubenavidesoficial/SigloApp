import Foundation

struct PrintModel: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let imageName: String
    let date: String
}

struct ClassifiedsModel: Identifiable {
    var id: String
    var seccion_nombre: String
    var anuncio: String
    var title: String
}
