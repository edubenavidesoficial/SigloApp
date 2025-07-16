import Foundation

struct IngresPortada: Codable {
    let id: Int
    let titulo: String
}

struct IngresPortadasResponse: Codable {
    let request_date: String
    let response: String
    let payload: [IngresPortada]
    let processing_time: String
}

