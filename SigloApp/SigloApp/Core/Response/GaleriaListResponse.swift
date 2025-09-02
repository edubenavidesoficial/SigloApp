import Foundation

struct GaleriaListResponse: Codable {
    let requestDate: String
    let response: String
    let payload: [GaleriaPayload]
    let processingTime: String
}

struct GaleriaPayload: Codable, Identifiable {
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
    let fotos: [GaleriaFoto]
    let fotosTotales: Int
    let fotosCuantas: Int
}

struct GaleriaFoto: Codable {
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

struct GaleriaResponse: Codable {
    let requestDate: String
    let response: String
    let payload: GaleriaPayload
    let processingTime: String
}
