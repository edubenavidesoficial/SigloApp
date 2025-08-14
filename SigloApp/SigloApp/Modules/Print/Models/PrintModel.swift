import Foundation

struct PrintModel: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var imageName: String
    var date: String
    var paginas: [String] // <-- agregar aquí
}



struct ClassifiedsModel: Identifiable {
    var id: String
    var seccion_nombre: String
    var anuncio: String
    var title: String
}
