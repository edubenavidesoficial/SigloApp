import Foundation

struct SectionResponse: Codable, Identifiable {
    var id: Int { payload.nombre.hashValue } // algo único
    let requestDate: String
    let response: String
    let message: String?
    let payload: SectionPayload
    let processingTime: String
}

struct SectionPayload: Codable, Identifiable {
    var id: Int { nombre.hashValue }
    let nombre: String
    let ordenar: Int
    let notas: [Noticia]?
    let videos: [Video]?
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
