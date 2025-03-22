import Foundation

// MARK: - PortadaResponse
struct PortadaResponse: Decodable, Equatable {
    let requestDate: String
    let response: String
    let version: String
    let payload: [String: SeccionPortada]

    enum CodingKeys: String, CodingKey {
        case requestDate = "request_date"
        case response
        case version
        case payload
    }

    static func ==(lhs: PortadaResponse, rhs: PortadaResponse) -> Bool {
        return lhs.requestDate == rhs.requestDate &&
            lhs.response == rhs.response &&
            lhs.version == rhs.version &&
            lhs.payload == rhs.payload
    }
}

// MARK: - SeccionPortada
struct SeccionPortada: Decodable, Equatable {
    let seccion: String
    let mostrarTitulo: Int
    let notas: [Nota]

    enum CodingKeys: String, CodingKey {
        case seccion
        case mostrarTitulo = "mostrar_titulo"
        case notas
    }

    static func ==(lhs: SeccionPortada, rhs: SeccionPortada) -> Bool {
        return lhs.seccion == rhs.seccion &&
            lhs.mostrarTitulo == rhs.mostrarTitulo &&
            lhs.notas == rhs.notas
    }
}

// MARK: - Nota
struct Nota: Decodable, Identifiable, Equatable {
    var id: UUID
    let sid: Int
    let fecha: String
    let fechamod: String
    let titulo: String
    let localizador: String
    let balazo: String?
    let autor: String?
    let ciudad: String?
    let contenido: [String]?
    let contenidoHTML: String
    let seccion: String
    let fotos: [Foto]
    let nombre: String
    let gid: Int
    let galeria: Galeria
    let plantilla: Int
    let votacion: String?
    let video: [String: String]
    let youtube: String?
    let facebook: String?
    let filemanager: String?
    let acceso: Int

    enum CodingKeys: String, CodingKey {
        case id, sid, fecha, fechamod, titulo, localizador, balazo, autor, ciudad, contenido
        case contenidoHTML = "contenidoHTML"
        case seccion, fotos, nombre, gid, galeria, plantilla, votacion, video, youtube, facebook, filemanager, acceso
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sid = try container.decode(Int.self, forKey: .sid)
        fecha = try container.decode(String.self, forKey: .fecha)
        fechamod = try container.decode(String.self, forKey: .fechamod)
        titulo = try container.decode(String.self, forKey: .titulo)
        localizador = try container.decode(String.self, forKey: .localizador)
        balazo = try container.decodeIfPresent(String.self, forKey: .balazo)
        autor = try container.decodeIfPresent(String.self, forKey: .autor)
        ciudad = try container.decodeIfPresent(String.self, forKey: .ciudad)
        contenido = try container.decodeIfPresent([String].self, forKey: .contenido)
        contenidoHTML = try container.decode(String.self, forKey: .contenidoHTML)
        seccion = try container.decode(String.self, forKey: .seccion)
        fotos = try container.decode([Foto].self, forKey: .fotos)
        nombre = try container.decode(String.self, forKey: .nombre)
        gid = try container.decode(Int.self, forKey: .gid)
        galeria = try container.decode(Galeria.self, forKey: .galeria)
        plantilla = try container.decode(Int.self, forKey: .plantilla)
        votacion = try container.decodeIfPresent(String.self, forKey: .votacion)
        video = try container.decode([String: String].self, forKey: .video)
        youtube = try container.decodeIfPresent(String.self, forKey: .youtube)
        facebook = try container.decodeIfPresent(String.self, forKey: .facebook)
        filemanager = try container.decodeIfPresent(String.self, forKey: .filemanager)
        acceso = try container.decode(Int.self, forKey: .acceso)

        // Generar un UUID único para cada nota
        id = UUID()
    }

    static func ==(lhs: Nota, rhs: Nota) -> Bool {
        return lhs.id == rhs.id &&
            lhs.sid == rhs.sid &&
            lhs.fecha == rhs.fecha &&
            lhs.fechamod == rhs.fechamod &&
            lhs.titulo == rhs.titulo &&
            lhs.localizador == rhs.localizador &&
            lhs.balazo == rhs.balazo &&
            lhs.autor == rhs.autor &&
            lhs.ciudad == rhs.ciudad &&
            lhs.contenido == rhs.contenido &&
            lhs.contenidoHTML == rhs.contenidoHTML &&
            lhs.seccion == rhs.seccion &&
            lhs.fotos == rhs.fotos &&
            lhs.nombre == rhs.nombre &&
            lhs.gid == rhs.gid &&
            lhs.galeria == rhs.galeria &&
            lhs.plantilla == rhs.plantilla &&
            lhs.votacion == rhs.votacion &&
            lhs.video == rhs.video &&
            lhs.youtube == rhs.youtube &&
            lhs.facebook == rhs.facebook &&
            lhs.filemanager == rhs.filemanager &&
            lhs.acceso == rhs.acceso
    }
}

// MARK: - Foto
struct Foto: Decodable, Equatable {
    let urlFoto: String
    let pieFoto: String?

    enum CodingKeys: String, CodingKey {
        case urlFoto = "url_foto"
        case pieFoto = "pie_foto"
    }

    static func ==(lhs: Foto, rhs: Foto) -> Bool {
        return lhs.urlFoto == rhs.urlFoto &&
            lhs.pieFoto == rhs.pieFoto
    }
}

// MARK: - Galeria
struct Galeria: Decodable, Equatable {
    let id: Int
    let sid: Int
    let titulo: String
    let contenido: String
    let autor: String
    let seccion: String
    let fecha: String
    let fechaFormato: String
    let url: String
    let tags: [String]
    let fotos: [FotoGaleria]
    let fotosTotales: Int
    let fotosCuantas: Int

    enum CodingKeys: String, CodingKey {
        case id, sid, titulo, contenido, autor, seccion, fecha
        case fechaFormato = "fecha_formato"
        case url, tags, fotos
        case fotosTotales = "fotos_totales"
        case fotosCuantas = "fotos_cuantas"
    }

    static func ==(lhs: Galeria, rhs: Galeria) -> Bool {
        return lhs.id == rhs.id &&
            lhs.sid == rhs.sid &&
            lhs.titulo == rhs.titulo &&
            lhs.contenido == rhs.contenido &&
            lhs.autor == rhs.autor &&
            lhs.seccion == rhs.seccion &&
            lhs.fecha == rhs.fecha &&
            lhs.fechaFormato == rhs.fechaFormato &&
            lhs.url == rhs.url &&
            lhs.tags == rhs.tags &&
            lhs.fotosTotales == rhs.fotosTotales &&
            lhs.fotosCuantas == rhs.fotosCuantas
    }
}

// MARK: - FotoGaleria
struct FotoGaleria: Decodable, Equatable {
    let id: Int
    let galeria: Int
    let titulo: String?
    let fecha: String
    let fechaFormato: String
    let url: String
    let urlWeb: String
    let visitas: String
    let tags: [String]

    enum CodingKeys: String, CodingKey {
        case id, galeria, titulo, fecha
        case fechaFormato = "fecha_formato"
        case url, urlWeb = "url_web", visitas, tags
    }

    static func ==(lhs: FotoGaleria, rhs: FotoGaleria) -> Bool {
        return lhs.id == rhs.id &&
            lhs.galeria == rhs.galeria &&
            lhs.titulo == rhs.titulo &&
            lhs.fecha == rhs.fecha &&
            lhs.fechaFormato == rhs.fechaFormato &&
            lhs.url == rhs.url &&
            lhs.urlWeb == rhs.urlWeb &&
            lhs.visitas == rhs.visitas &&
            lhs.tags == rhs.tags
    }
}
