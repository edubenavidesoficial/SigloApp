import Foundation

struct CommentVoteResponse: Codable {
    let requestDate: String
    let response: String
    let message: String
    let payload: CommentVotePayload
    let processingTime: String
}

import Foundation

struct CommentVotePayload: Codable {
    let id: Int
    let nid: Int
    let usuario: CommentUser
    let contenido: String
    let fecha: String
    let fechaFormato: String
    let likes: Int
    let dislikes: Int
    let respuestas: [CommentVoteReply]
}

struct CommentUser: Codable {
    let nombre: String
    let alias: String
}

struct CommentVoteReply: Codable {
    // Asumiendo que las respuestas son similares a comentarios.
    // Puedes definir la estructura si son necesarias.
}
