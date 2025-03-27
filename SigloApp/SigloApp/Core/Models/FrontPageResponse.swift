import Foundation

// Modelo para la respuesta completa
struct PortadaResponse: Decodable {
    let request_date: String
    let response: String
    let version: String
    let payload: [String: SeccionPortada] // El payload es un diccionario con diferentes claves de secciones
}

// Modelo para la sección de la portada
struct SeccionPortada: Decodable {
    let seccion: String?
    let mostrar_titulo: Int
    let notas: [Nota]? // 'notas' es opcional, ya que puede no existir en algunas secciones
}

// Modelo para la nota
struct Nota: Decodable, Sendable {
    let id: Int
    let sid: Int
    let fecha: String
    let fechamod: String
    let fecha_formato: String
    let titulo: String
    let localizador: String
    let balazo: String?
    let autor: String
    let ciudad: String
    let contenido: [String]
}
