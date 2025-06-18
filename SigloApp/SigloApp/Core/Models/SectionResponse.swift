import Foundation

struct SectionResponse: Codable {
    let requestDate: String
    let response: String
    let message: String?
    let payload: SectionPayload
    let processingTime: String

    private enum CodingKeys: String, CodingKey {
        case requestDate = "request_date"
        case response
        case message
        case payload
        case processingTime = "processing_time"
    }
}

struct SectionPayload: Codable, Identifiable {
    let id: Int
    let nombre: String
    let tipo: String
    let logo: String?
    let notas: [Noticia]?
    let videos: [Video]?   // Asegúrate que Video esté definido y sea Codable

    private enum CodingKeys: String, CodingKey {
        case id
        case nombre = "titulo"
        case tipo
        case logo
        case notas
        case videos
    }
}

struct FotoNota: Codable {
    let urlFoto: String
    let pieFoto: String?
}

struct FotoGaleria: Codable {
    let id: Int
    let galeria: Int
    let titulo: String?
    let fecha: String
    let fechaFormato: String
    let url: String
    let urlWeb: String
    let visitas: String
    let tags: [String]
}

struct Noticia: Codable, Identifiable {
    let id: Int
    let sid: Int
    let fecha: String
    let fechamod: String
    let fechaFormato: String
    let titulo: String
    let localizador: String?
    let balazo: String?
    let autor: String?
    let ciudad: String?
    let contenido: [String]?
    let contenidoHTML: String?
    let seccion: String
    let fotos: [FotoNota]?
    let nombre: String
    let gid: Int?
    let galeria: Galeria?
    let plantilla: Int?
    let votacion: Int?
    let video: [String: String]? // ajusta si es necesario
    let youtube: String?
    let facebook: String?
    let filemanager: String?
    let acceso: Int
}
