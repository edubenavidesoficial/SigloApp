import Foundation

struct SectionSingleResponse: Decodable {
    let payload: SectionPayload
}

// Respuesta para lista de secciones
struct SectionListResponse: Decodable {
    let requestDate: String
    let response: String
    let message: String?
    let payload: [SectionPayload]
    let processingTime: String?
}

// Respuesta para detalle de sección
struct SectionDetailResponse: Decodable {
    let requestDate: String
    let response: String
    let message: String?
    let payload: SectionPayload
    let processingTime: String

    private enum CodingKeys: String, CodingKey {
        case requestDate = "request_date"
        case response, message, payload
        case processingTime = "processing_time"
    }
}

// Modelo SectionPayload con init personalizado para solo decodificar
struct SectionPayload: Decodable, Identifiable {
    let sectionId: Int?
    var id: Int? { sectionId }
    let nombre: String
    let ordenar: Int?
    let tipo: String?
    let logo: String?
    let notas: [Noticia]?
    let videos: [SectionVideo]?

    private enum CodingKeys: String, CodingKey {
        case sectionId = "id"
        case ordenar, tipo, logo, notas, videos
        case nombre
        case titulo
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sectionId = try container.decodeIfPresent(Int.self, forKey: .sectionId)
        ordenar = try container.decodeIfPresent(Int.self, forKey: .ordenar)
        tipo = try container.decodeIfPresent(String.self, forKey: .tipo)
        logo = try container.decodeIfPresent(String.self, forKey: .logo)
        notas = try container.decodeIfPresent([Noticia].self, forKey: .notas)
        videos = try container.decodeIfPresent([SectionVideo].self, forKey: .videos)

        if let nombreValue = try? container.decode(String.self, forKey: .nombre) {
            nombre = nombreValue
        } else if let tituloValue = try? container.decode(String.self, forKey: .titulo) {
            nombre = tituloValue
        } else {
            nombre = "Sin título"
        }
    }
}

// FotoGaleria
struct FotoGaleria: Decodable {
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

// Noticia
struct Noticia: Decodable, Identifiable {
    let id: Int
    let sid: Int
    let fecha: String
    let fechamod: String
    let fechaFormato: String?
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
    let video: SectionVideo?
    let youtube: String?
    let facebook: String?
    let filemanager: String?
    let acceso: Int
}

extension Noticia {
    init(from nota: Nota) {
        self.id = nota.id
        self.sid = 0
        self.fecha = nota.fecha
        self.fechamod = nota.fechamod
        self.fechaFormato = nota.fecha_formato
        self.titulo = nota.titulo
        self.localizador = nota.localizador
        self.balazo = nota.balazo
        self.autor = nota.autor
        self.ciudad = nota.ciudad
        self.contenido = nota.contenido
        self.contenidoHTML = nil
        self.seccion = ""
        self.fotos = nota.fotos.map { FotoNota(urlFoto: $0.url_foto ?? "", pieFoto: $0.pie_foto) }
        self.nombre = ""
        self.gid = nil
        self.galeria = nil
        self.plantilla = nil
        self.votacion = nil
        self.video = nil
        self.youtube = nil
        self.facebook = nil
        self.filemanager = nil
        self.acceso = 0
    }
}

// FotoNota
struct FotoNota: Decodable {
    let urlFoto: String
    let pieFoto: String?

    private enum CodingKeys: String, CodingKey {
        case urlFoto = "url_foto"
        case pieFoto = "pie_foto"
    }
}

struct SectionVideo: Identifiable, Decodable {
    let id: Int?
    let url: String?
    let titulo: String?
    let contenido: String?
    let cover: String?
    let fecha: String?
    let tipo: String?
    let seccion: String?
    let fechaformato: String?

    var safeId: Int { id ?? UUID().hashValue }

    private enum CodingKeys: String, CodingKey {
        case id, url, titulo, contenido, cover, fecha, tipo, seccion
        case fechaformato = "fecha_formato"
    }
}

