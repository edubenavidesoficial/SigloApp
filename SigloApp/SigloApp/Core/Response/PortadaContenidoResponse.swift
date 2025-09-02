import Foundation

struct PortadaContenidoResponse: Decodable {
    let request_date: String
    let response: String
    let payload: Payload
    let processing_time: String
}

struct Payload: Decodable {
    let nombre: String
    let ordenar: Int
    let notas: [Nota]?
    let videos: [Video]?
    let galerias: [Galeria]?
    enum CodingKeys: String, CodingKey {
        case nombre, ordenar, notas, videos, galerias
    }
}
