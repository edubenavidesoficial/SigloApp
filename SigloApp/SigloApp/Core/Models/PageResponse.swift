import Foundation

// Modelo para la respuesta completa
struct PortadaResponse: Decodable {
    let request_date: String
    let response: String
    let version: String
    let payload: [String: SeccionPortada]
}


// Modelo para la sección de la portada
struct SeccionPortada: Decodable {
    let seccion: String?
    let mostrar_titulo: Int
    let notas: [Nota]?
}

// Modelo para la foto
struct Foto: Decodable, Sendable {
    let url_foto: String
    let pie_foto: String?
}

// Modelo para la nota
struct Nota: Decodable, Sendable {
    let id: Int
    let sid: Int
    let fecha: String
    let fechamod: String
    let fecha_formato: String
    let titulo: String
    let localizador: String
    let balazo: String?
    let autor: String
    let ciudad: String
    let contenido: [String]
    let fotos: [Foto]
}

// MARK: - Modelos de Datos PRINT
struct NewspaperResponse: Codable {
    let requestDate: String
    let response: String
    let payload: [NewspaperPayload]
}

struct NewspaperPayload: Codable {
    let fecha: String
    let portadas: [Portada]
}

struct Portada: Codable {
    var letra: String
    var cover: String
    var titulo: String
    var pagina: Int
    var paginas: [String]? // Se hace opcional
}


struct NewspaperEdition: Codable {
    let fecha: String
    let portadas: [NewspaperCover]
    let paginas: [String]
}

struct NewspaperCover: Codable {
    let letra: String
    let cover: String
    let titulo: String
    let pagina: Int
}

// MARK: - Manejo de Errores
enum NetworkError: Error {
    case invalidURL
    case noData
    case invalidResponse
    case emptyData
    case missingPayload(String)
    case decodingError(Error)
    
}

// MARK: - Respuesta general del API
struct SuplementoResponse: Codable {
    let requestDate: String
    let response: String
    let payload: [SuplementoPayload]

    enum CodingKeys: String, CodingKey {
        case requestDate = "request_date"
        case response
        case payload
    }
}

struct SuplementoPayload: Codable {
    let id: Int
    let titulo: String
    let ruta: String
    let fecha: String
    let portada: String
    let sitioWeb: String
    let portadaWeb: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case titulo
        case ruta
        case fecha
        case portada
        case sitioWeb = "sitio_web"
        case portadaWeb = "portada_web"
    }
}

// MARK: - Modelo de Portada
struct PortadaMenu: Decodable {
    let id: Int
    let titulo: String
}

// MARK: - Respuesta del servidor
struct PortadaMenuResponse: Decodable {
    let request_date: String
    let response: String
    let payload: [PortadaMenu]
    let processing_time: String
}

struct Video: Codable {
    let id: Int
    let sid: Int
    let titulo: String
    let contenido: String?
    let seccion: String
    let url: String
    let cover: String?
    let url_web: String
    let fecha: String
    let fecha_formato: String
    let tags: [String]
    let tipo: String
}


struct BusquedaResponse: Codable {
    let payload: [ArticuloPayload]
}

struct ArticuloPayload: Codable {
    let id: Int
    let titulo: String
    let descripcion: String?
    let fecha: String
}
