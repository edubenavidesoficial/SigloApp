import Foundation

struct NewsResponse: Decodable {
    let response: String
    let payload: NewsArticle
}

struct NewsArticle: Decodable {
    let id: Int
    let sid: Int
    let fecha: String
    let fechamod: String
    let fecha_formato: String?
    let titulo: String
    let localizador: String
    let balazo: String?
    let autor: String
    let ciudad: String
    let contenido: [String]
    let contenidoHTML: String?
    let seccion: String?
    let fotos: [NewsPhoto]
    let nombre: String
    let gid: Int?
    let galeria: Galeria?
    let plantilla: Int
    let votacion: String?
    let video: Video?
    let youtube: String?
    let facebook: String?
    let filemanager: String?
    let tags: [String]?
    let acceso: Int
    let explicita: Bool?
    let relacionadas: [Nota?]?
    let masNotas: [Nota]?
}

struct NewsPhoto: Decodable {
    let url_foto: String?
    let pie_foto: String?
}
