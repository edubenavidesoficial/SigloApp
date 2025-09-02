import Foundation

struct VideoResponse: Codable {
    let requestDate: String
    let response: String
    let payload: VideoPayload
    let processingTime: String
}

struct VideoPayload: Codable {
    let id: Int
    let sid: Int
    let titulo: String
    let contenido: String
    let seccionNombre: String
    let seccion: String
    let url: String
    let cover: String
    let urlWeb: String
    let fecha: String
    let fechaFormato: String
    let tags: [String]
    let tipo: String
    let relacionados: [VideoRelacionado]
}

struct VideoRelacionado: Codable {
    let id: Int
    let sid: Int
    let titulo: String
    let contenido: String
    let seccionNombre: String
    let seccion: String
    let url: String
    let cover: String
    let urlWeb: String
    let fecha: String
    let fechaFormato: String
    let tags: [String]
    let tipo: String
}
