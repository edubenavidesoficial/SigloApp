import Foundation

struct TendenciaResponse: Codable {
    let request_date: String
    let response: String
    let payload: [TendenciaArticulo]
}

struct TendenciaArticulo: Codable, Identifiable {
    let id: Int
    let sid: Int
    let fecha: String
    let fechamod: String
    let fecha_formato: String
    let titulo: String
    let localizador: String
    let balazo: String
    let autor: String
    let ciudad: String
    let contenido: [String]
    let contenidoHTML: String
    let seccion: String
    let fotos: [String]?
    let nombre: String
    let galeria: String?
    let plantilla: Int
    let votacion: String?
    let video: [String: String]?
    let youtube: String?
    let facebook: String?
    let filemanager: String?
    let acceso: Int
}
