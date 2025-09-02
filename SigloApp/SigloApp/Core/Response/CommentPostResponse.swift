import Foundation

struct CommentPostResponse: Codable {
    let requestDate: String
    let response: String
    let message: String
    let payload: CommentPostPayload?
    let processingTime: String
}

struct CommentPostPayload: Codable {
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
