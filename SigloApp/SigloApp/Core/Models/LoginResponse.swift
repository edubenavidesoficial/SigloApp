//
//  use.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 6/12/25.
//

import Foundation

struct LoginResponse: Codable {
    let token: String
    let usuario: UserDetailPayload
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
