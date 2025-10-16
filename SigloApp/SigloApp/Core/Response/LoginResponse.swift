import Foundation

struct LoginResponse: Codable {
    let response: String
    let payload: UserPayload?
    let requestDate: String
    let processingTime: String

    enum CodingKeys: String, CodingKey {
        case response
        case payload
        case requestDate = "request_date"
        case processingTime = "processing_time"
    }
}

struct UserPayload: Codable {
    let id: Int
    let usuario: String
    let correo: String
    let nombre: String
    let apellidos: String
    let nombre_largo: String
    let nombre_corto: String
    let nombre_iniciales: String
    let activo: Bool

    enum CodingKeys: String, CodingKey {
        case id, usuario, correo, nombre, apellidos, nombre_largo, nombre_corto, nombre_iniciales, activo
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        usuario = try container.decode(String.self, forKey: .usuario)
        correo = try container.decode(String.self, forKey: .correo)
        nombre = try container.decode(String.self, forKey: .nombre)
        apellidos = try container.decode(String.self, forKey: .apellidos)
        nombre_largo = try container.decode(String.self, forKey: .nombre_largo)
        nombre_corto = try container.decode(String.self, forKey: .nombre_corto)
        nombre_iniciales = try container.decode(String.self, forKey: .nombre_iniciales)
        activo = try container.decode(Bool.self, forKey: .activo) 
    }


    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(usuario, forKey: .usuario)
        try container.encode(correo, forKey: .correo)
        try container.encode(nombre, forKey: .nombre)
        try container.encode(apellidos, forKey: .apellidos)
        try container.encode(nombre_largo, forKey: .nombre_largo)
        try container.encode(nombre_corto, forKey: .nombre_corto)
        try container.encode(nombre_iniciales, forKey: .nombre_iniciales)
        try container.encode(activo, forKey: .activo)
    }
}


struct UserDetailPayload: Codable, Equatable {
    let id: Int
    let usuario: String?
    let correo: String
    let nombre: String
    let apellidos: String
    let nombreLargo: String
    let nombreCorto: String
    let nombreIniciales: String
    let activo: Bool
    let suscriptor: Bool
    let accesoA: Bool
    let accesoH: Bool
    let menosPub: Bool
    let susNumero: Int
    let susTarjeta: Int
    let susImpresa: Bool
    let admin: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case usuario
        case correo
        case nombre
        case apellidos
        case nombreLargo = "nombre_largo"
        case nombreCorto = "nombre_corto"
        case nombreIniciales = "nombre_iniciales"
        case activo
        case suscriptor
        case accesoA = "acceso_a"
        case accesoH = "acceso_h"
        case menosPub = "menos_pub"
        case susNumero = "sus_numero"
        case susTarjeta = "sus_tarjeta"
        case susImpresa = "sus_impresa"
        case admin
    }
}

struct TokenResponse: Codable {
    let request_date: String
    let response: String
    let token: String
    let processing_time: String
}

enum TokenServiceError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    case missingCredentials
}
