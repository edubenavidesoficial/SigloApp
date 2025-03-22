//
//  FrontPageResponse.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/22/25.
//

import Foundation

struct SeccionPortada: Identifiable, Hashable {
    var id: String { seccion }
    let seccion: String
    let notas: [Nota]  // ← Aquí el cambio: de "nota" a "notas"
}

struct Nota: Identifiable, Decodable, Hashable {
    let id: Int
    let titulo: String
    let balazo: String?
    let autor: String?
    let ciudad: String?
    let contenido: [String]?
    let fotos: [String]?
    let seccion: String
}
