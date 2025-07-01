import Foundation

struct NewsResponse: Codable {
    let response: String
    let payload: NewsArticle
}

struct NewsArticle: Codable {
    let id: Int
    let titulo: String
    let localizador: String
    let balazo: String?
    let autor: String?
    let ciudad: String?
    let fecha: String
    let fechamod: String
    let seccion: String?
    let contenido: [String]
    let contenidoHTML: String?
    let fotos: [NewsPhoto]
    let nombre: String
    let tags: [String]?
}

struct NewsPhoto: Codable {
    let urlFoto: String
    let pieFoto: String?
}
