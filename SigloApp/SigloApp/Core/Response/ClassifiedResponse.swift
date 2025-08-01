import Foundation


struct ClasificadosResponse: Decodable {
    let request_date: String
    let response: String
    let payload: [String: ClasificadoSeccion]
}


struct ClasificadoSeccion: Decodable {
    let nombre: String
    let categorias: [String: ClasificadoCategoria]
}


struct ClasificadoCategoria: Decodable {
    let nombre: String
    let categorias: [String: ClasificadoCategoria]?

    // Decodificación especial para manejar casos como [] o {} en JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        nombre = try container.decode(String.self, forKey: .nombre)

        // Intentamos decodificar como diccionario
        if let dict = try? container.decode([String: ClasificadoCategoria].self, forKey: .categorias) {
            categorias = dict
        } else if (try? container.decode([EmptyCategory].self, forKey: .categorias)) != nil {
            categorias = [:] // Si viene un array vacío: []
        } else {
            categorias = [:] // Si no viene nada o viene mal
        }
    }

    private enum CodingKeys: String, CodingKey {
        case nombre, categorias
    }

    // Estructura dummy para detectar []
    private struct EmptyCategory: Decodable {}
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
    let foto: String?
    let seccion: String
    let seccionNombre: String?
    let clasif1: String?
    let clasif1Nombre: String?
    let clasif2: String?
    let clasif2Nombre: String?
    let clasif3: String?
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
    let fotos: [String]? 

    private enum CodingKeys: String, CodingKey {
        case id, numero, orden, foto, seccion
        case seccionNombre = "seccion_nombre"
        case clasif1 = "clasif_1"
        case clasif1Nombre = "clasif_1_nombre"
        case clasif2 = "clasif_2"
        case clasif2Nombre = "clasif_2_nombre"
        case clasif3 = "clasif_3"
        case clasif3Nombre = "clasif_3_nombre"
        case anuncio, anuncioHTML, masTexto, masTextoHTML, marco, color, whatsapp, youtube, filemanger
        case fotos
    }
}

struct SimpleAd: Identifiable {
    let id: String
    let seccionNombre: String?
    let anuncio: String
    let fotos: [String]? 
}


struct AdDetailResponse: Decodable {
    let requestDate: String
    let response: String
    let payload: ClassifiedAd
    let processingTime: String
}

struct AnuncioSeccion: Codable {
    let seccion: String
    let nombreSeccion: String
    let items: [AnuncioItem]

    enum CodingKeys: String, CodingKey {
        case seccion
        case nombreSeccion = "seccion_nombre"
        case items
    }
}

struct AnuncioItem: Codable {
    let id: Int   // Aquí es Int porque el JSON lo envía así
    let titulo: String
    let descripcion: String?
    let observaciones: String?
    let whatsapp: String?
    let imagen: String
    let fecha: String
    let fechaFormato: String

    enum CodingKeys: String, CodingKey {
        case id, titulo, descripcion, observaciones, whatsapp, imagen, fecha
        case fechaFormato = "fecha_formato"
    }
}

struct AnuncioResponse: Codable {
    let request_date: String
    let response: String
    let payload: [AnuncioSeccion]
    let processing_time: String
}
