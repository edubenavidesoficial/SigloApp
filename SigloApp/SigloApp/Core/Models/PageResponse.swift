import Foundation


struct UserSuccessResponse: Codable {
    let requestDate: String
    let response: String
    let payload: UserDetailPayload
    let processingTime: String

    enum CodingKeys: String, CodingKey {
        case requestDate = "request_date"
        case response
        case payload
        case processingTime = "processing_time"
    }
}

struct UserErrorResponse: Codable {
    let requestDate: String
    let response: String
    let message: String
    let processingTime: String

    enum CodingKeys: String, CodingKey {
        case requestDate = "request_date"
        case response
        case message
        case processingTime = "processing_time"
    }
}

struct PortadaResponse: Decodable {
    let request_date: String
    let response: String
    let version: String
    let payload: [String: SeccionPortada]
}

struct SeccionPortada: Decodable {
    let seccion: String?
    let mostrar_titulo: Int
    let notas: [Nota]?
}

struct Foto: Codable, Sendable {
    let url_foto: String
    let pie_foto: String?
}

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

struct NewspaperResponse: Codable {
    let requestDate: String
    let response: String
    let payload: [NewspaperPayload]
}

struct NewspaperPayload: Codable, Identifiable {
    let id: Int?
    let title: String?
    let pdfUrl: URL?
    let date: String?
    let fecha: String?
    let portadas: [Portada]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case pdfUrl    = "pdf_url"
        case date
        case fecha
        case portadas
    }
}

struct Portada: Codable {
    var letra: String
    var cover: String
    var titulo: String
    var pagina: Int
    var paginas: [String]? 
    var id: String?
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

enum NetworkError: Error {
    case invalidURL
    case noData
    case invalidResponse
    case emptyData
    case missingPayload(String)
    case decodingError(Error)
    case decodingFailed
    case invalidToken
    case custom(String) 
}

struct SuplementoResponse: Identifiable, Codable {
    let requestDate: String
    let response: String
    let payload: [SuplementoPayload]
    let processingTime: String

    var id: String { requestDate }

    enum CodingKeys: String, CodingKey {
        case requestDate = "request_date"
        case response
        case payload
        case processingTime = "processing_time"
    }
}

struct SuplementoPayload: Identifiable, Codable {
    let id: Int
    let titulo: String
    let ruta: String
    let fecha: String
    let portada: String
    let sitioWeb: String
    let portadaWeb: Bool
    let anio: Int?
    let numero: Int?
    let paginasCuantas: Int?
    let paginas: [String]?
    let contenido: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case titulo
        case ruta
        case fecha
        case portada
        case sitioWeb = "sitio_web"
        case portadaWeb = "portada_web"
        case anio
        case numero
        case paginasCuantas = "paginas_cuantas"
        case paginas
        case contenido
    }
}


struct PortadaMenu: Decodable {
    let id: Int
    let titulo: String
}

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

struct BusquedaResponsee: Decodable{
    let request_date: String
    let response: String
    let payload: [ArticuloPayload]
    let processing_time: String
}

struct PayloadItem: Codable {
    // otras propiedades
    let galeria: Galeria?
}

struct Galeria: Codable {
    // Define aquí las propiedades según el JSON real que recibes dentro de galeria
    // Ejemplo:
    let imagenes: [String]?
    // o si no tienes estructura fija:
    // let data: [String: AnyCodable]? // usando AnyCodable o algo similar
}


struct ArticuloPayload: Decodable{
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
    let contenido: [String]
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

struct ContenidoItem: Decodable {
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
    let contenidoTexto: String?
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

    enum CodingKeys: String, CodingKey {
        case id, sid, fecha, fechamod, fecha_formato, titulo, localizador,
             balazo, autor, ciudad, contenido, contenidoHTML, seccion,
             fotos, nombre, galeria, plantilla, votacion, video, youtube,
             facebook, filemanager, acceso
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        sid = try container.decodeIfPresent(Int.self, forKey: .sid)
        fecha = try container.decodeIfPresent(String.self, forKey: .fecha)
        fechamod = try container.decodeIfPresent(String.self, forKey: .fechamod)
        fecha_formato = try container.decodeIfPresent(String.self, forKey: .fecha_formato)
        titulo = try container.decode(String.self, forKey: .titulo)
        localizador = try container.decodeIfPresent(String.self, forKey: .localizador)
        balazo = try container.decodeIfPresent(String.self, forKey: .balazo)
        autor = try container.decodeIfPresent(String.self, forKey: .autor)
        ciudad = try container.decodeIfPresent(String.self, forKey: .ciudad)

        // contenido puede venir como array de strings, string simple o incluso como objeto
        if let array = try? container.decode([String].self, forKey: .contenido) {
            contenidoTexto = array.joined(separator: "\n")
        } else if let string = try? container.decode(String.self, forKey: .contenido) {
            contenidoTexto = string
        } else {
            contenidoTexto = nil
        }

        contenidoHTML = try container.decodeIfPresent(String.self, forKey: .contenidoHTML)
        seccion = try container.decodeIfPresent(String.self, forKey: .seccion)
        fotos = try container.decodeIfPresent([Foto].self, forKey: .fotos)
        nombre = try container.decodeIfPresent(String.self, forKey: .nombre)
        galeria = try container.decodeIfPresent(String.self, forKey: .galeria)
        plantilla = try container.decodeIfPresent(Int.self, forKey: .plantilla)
        votacion = try container.decodeIfPresent(String.self, forKey: .votacion)
        video = try container.decodeIfPresent([String: String].self, forKey: .video)
        youtube = try container.decodeIfPresent(String.self, forKey: .youtube)
        facebook = try container.decodeIfPresent(String.self, forKey: .facebook)
        filemanager = try container.decodeIfPresent(String.self, forKey: .filemanager)
        acceso = try container.decodeIfPresent(Int.self, forKey: .acceso)
    }
}

struct Root: Decodable {
    let request_date: String
    let response: String
    let payload: [MenuItem]
}

struct MenuItem: Decodable {
    let titulo: String
    let contenido: [ContenidoItem]
}

struct BusquedaResponse: Decodable {
    let requestDate: String
    let response: String
    let payload: [Categoria]
}

struct Categoria: Identifiable, Decodable {
    var id: String { titulo }
    let titulo: String
    let contenido: [Contenido]
}

struct Contenido: Identifiable, Codable {
    let id: String
    let titulo: String
    let balazo: String?

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
                debugDescription: "String or Int"
            ))
        }

        self.titulo = try container.decode(String.self, forKey: .titulo)
        self.balazo = try? container.decode(String.self, forKey: .balazo) // Opcional
    }
}

struct SuscripcionResponse: Codable {
    let requestDate: String
    let response: String
    let payload: SuscripcionPayload
    let processingTime: String
}

struct SuscripcionPayload: Codable {
    let id: Int
    let suscriptor: Bool
    let accesoA: Bool
    let accesoH: Bool
    let menosPub: Bool
    let urlSuscribirse: String
    let urlTarjetaImagen: String
    let suscripcionDigital: SuscripcionDetalle
    let suscripcionImpresa: SuscripcionDetalle
}

struct SuscripcionDetalle: Codable {
    let urlArchivoDigital: String?
    let numero: String
    let tarjeta: String
    let vigencia: String?
    let periodo: String?
    let estado: String?
    let extras: [String]
}
