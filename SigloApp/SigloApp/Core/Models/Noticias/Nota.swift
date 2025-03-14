//
//  Nota.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/14/25.
//
// Nota.swift
struct Nota: Identifiable, Decodable {
    let id: Int
    let titulo: String
    let balazo: String?
    let autor: String?
    let ciudad: String?
    let contenido: [String]?
    let fotos: [String]?
    let seccion: String
}
