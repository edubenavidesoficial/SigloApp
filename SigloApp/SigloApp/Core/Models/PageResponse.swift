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

struct Foto: Codable, Sendable {
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


struct BusquedaResponsee: Codable{
    let request_date: String
    let response: String
    let payload: [ArticuloPayload]
    let processing_time: String
}

struct ArticuloPayload: Identifiable, Codable{
    let id: Int
    let sid: Int
    let fecha: String
    let fechamod: String
    let fecha_formato: String
    let titulo: String
    let localizador: String
    let balazo: String?
    let autor: String
    let ciudad: String?
    let contenido: [ContenidoItem]
    let seccion: String
    let descripcion: String?
    let nombre: String
    let galeria: String?
    let plantilla: Int
    let votacion: String?
    //let video: VideoInfoOrEmpty?
    let youtube: String?
    let facebook: String?
    let filemanager: String?
    let acceso: Int
    
    struct VideoInfoOrEmpty: Codable {
        let contenido: String?
        let cover: String?
        let fecha: String?
        let fecha_formato: String?
        let id: Int?
        let seccion: String?
        let seccion_nombre: Int?       // queremos Int
        let sid: Int?
        let tags: [String]?
        let tipo: String?
        let titulo: String?
        let url: String?
        let url_web: String?

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            contenido = try container.decodeIfPresent(String.self, forKey: .contenido)
            cover = try container.decodeIfPresent(String.self, forKey: .cover)
            fecha = try container.decodeIfPresent(String.self, forKey: .fecha)
            fecha_formato = try container.decodeIfPresent(String.self, forKey: .fecha_formato)
            id = try container.decodeIfPresent(Int.self, forKey: .id)
            seccion = try container.decodeIfPresent(String.self, forKey: .seccion)

            // Aquí decodificamos seccion_nombre flexible
            if let intValue = try? container.decode(Int.self, forKey: .seccion_nombre) {
                seccion_nombre = intValue
            } else if let stringValue = try? container.decode(String.self, forKey: .seccion_nombre), let intFromString = Int(stringValue) {
                seccion_nombre = intFromString
            } else {
                seccion_nombre = nil
            }

            sid = try container.decodeIfPresent(Int.self, forKey: .sid)
            tags = try container.decodeIfPresent([String].self, forKey: .tags)
            tipo = try container.decodeIfPresent(String.self, forKey: .tipo)
            titulo = try container.decodeIfPresent(String.self, forKey: .titulo)
            url = try container.decodeIfPresent(String.self, forKey: .url)
            url_web = try container.decodeIfPresent(String.self, forKey: .url_web)
        }
    }
}

struct ContenidoItem: Codable {
    let id: Int?
    let sid: Int?
    let fecha: String?
    let fechamod: String?
    let fecha_formato: String?
    let titulo: String
    let localizador: String?
    let balazo: String?
    let autor: String?
    let ciudad: String?
    let contenido: [String]?
    let contenidoHTML: String?
    let seccion: String?
    let fotos: [Foto]?
    let nombre: String?
    let galeria: String?
    let plantilla: Int?
    let votacion: String?
    let video: [String: String]?
    let youtube: String?
    let facebook: String?
    let filemanager: String?
    let acceso: Int?
}

struct Root: Codable {
    let request_date: String
    let response: String
    let payload: [MenuItem]
}

struct MenuItem: Codable {
    let titulo: String
    let contenido: [ContenidoItem]
}

struct BusquedaResponse: Decodable {
    let requestDate: String
    let response: String
    let payload: [Categoria]
}

struct Categoria: Identifiable, Decodable {
    var id: String { titulo }  // ID basado en el título
    let titulo: String
    let contenido: [Contenido]
}

struct Contenido: Identifiable, Codable {
    let id: String
    let titulo: String
    let balazo: String? // Si lo usas, asegúrate de tenerlo en el JSON

    private enum CodingKeys: String, CodingKey {
        case id, titulo, balazo
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decodificación flexible
        if let idString = try? container.decode(String.self, forKey: .id) {
            self.id = idString
        } else if let idInt = try? container.decode(Int.self, forKey: .id) {
            self.id = String(idInt)
        } else {
            throw DecodingError.typeMismatch(String.self, .init(
                codingPath: decoder.codingPath,
                debugDescription: "Expected id to be String or Int"
            ))
        }

        self.titulo = try container.decode(String.self, forKey: .titulo)
        self.balazo = try? container.decode(String.self, forKey: .balazo) // Opcional
    }
}


