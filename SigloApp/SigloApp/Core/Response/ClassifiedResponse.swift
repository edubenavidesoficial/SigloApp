import Foundation

// Nivel raíz de la respuesta
struct ClassifiedsResponse: Decodable {
    let requestDate: String
    let response: String
    let payload: [String: ClassifiedSection]
    let processingTime: String
}

// Sección principal (ej: "Inmuebles")
struct ClassifiedSection: Decodable {
    let nombre: String
    let categorias: [String: ClassifiedCategory1]?
}

// Nivel 1 de categoría (ej: "Inmuebles - Compra/Venta")
struct ClassifiedCategory1: Decodable {
    let nombre: String
    let categorias: [String: ClassifiedCategory2]?
}

// Nivel 2 de categoría (ej: "Torreón", "Gómez/Lerdo")
struct ClassifiedCategory2: Decodable {
    let nombre: String
    let categorias: [String: String]

    enum CodingKeys: String, CodingKey {
        case nombre, categorias
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        nombre = try container.decode(String.self, forKey: .nombre)
        
        if let dict = try? container.decode([String: String].self, forKey: .categorias) {
            categorias = dict
        } else if var unkeyedContainer = try? container.nestedUnkeyedContainer(forKey: .categorias) {
            // Es un array
            if unkeyedContainer.isAtEnd {
                categorias = [:] // Array vacío, asignamos diccionario vacío
            } else {
                throw DecodingError.dataCorruptedError(forKey: .categorias,
                                                       in: container,
                                                       debugDescription: "Expected dictionary or empty array for categorias")
            }
        } else {
            throw DecodingError.dataCorruptedError(forKey: .categorias,
                                                   in: container,
                                                   debugDescription: "Expected dictionary or empty array for categorias")
        }
    }
}

struct AdsResponse: Decodable {
    let requestDate: String
    let response: String
    let payload: [ClassifiedAd]
    let processingTime: String
}

struct ClassifiedAd: Decodable, Identifiable {
    let id: String
    let numero: String
    let orden: String
    let foto: String
    let seccion: String
    let seccionNombre: String
    let clasif1: String
    let clasif1Nombre: String
    let clasif2: String
    let clasif2Nombre: String
    let clasif3: String
    let clasif3Nombre: String?
    let anuncio: String
    let anuncioHTML: String
    let masTexto: String?
    let masTextoHTML: String?
    let marco: Bool
    let color: String?
    let whatsapp: String?
    let youtube: String?
    let filemanger: String?

    private enum CodingKeys: String, CodingKey {
        case id, numero, orden, foto, seccion, seccionNombre = "seccion_nombre",
             clasif1 = "clasif_1", clasif1Nombre = "clasif_1_nombre",
             clasif2 = "clasif_2", clasif2Nombre = "clasif_2_nombre",
             clasif3 = "clasif_3", clasif3Nombre = "clasif_3_nombre",
             anuncio, anuncioHTML, masTexto, masTextoHTML, marco, color,
             whatsapp, youtube, filemanger
    }
}

struct AdDetailResponse: Decodable {
    let requestDate: String
    let response: String
    let payload: ClassifiedAd
    let processingTime: String
}
