import Foundation

final class CommentPostService {
    static let shared = CommentPostService()
    private init() {}

    func postComment(noteId: Int,sectionId: Int, parentCommentId: Int = 0, userId: Int, content: String, completion: @escaping (Result<CommentPostPayload, Error>) -> Void
    ) {
        // Codificar el comentario en base64
        guard let encodedComment = content.data(using: .utf8)?.base64EncodedString() else {
            print("❌ Error al codificar el comentario")
            completion(.failure(NetworkError.emptyData))
            return
        }

        let urlString = "\(API.baseURL)comentarios/nuevo/\(noteId)/\(sectionId)/\(parentCommentId)/\(userId)/\(encodedComment)"
        guard let url = URL(string: urlString) else {
            print("❌ URL inválida: \(urlString)")
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Token
        if let token = TokenService.shared.getStoredToken() {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        } else {
            print("⚠️ Token no disponible")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Error de red: \(error)")
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ Respuesta inválida")
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    print("❌ Error HTTP: \(httpResponse.statusCode)")
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }

                guard let data = data else {
                    print("❌ Sin datos")
                    completion(.failure(NetworkError.emptyData))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(CommentPostResponse.self, from: data)

                    if response.message.contains("No puede enviar") {
                        print("⚠️ Mensaje del servidor: \(response.message)")
                        completion(.failure(NetworkError.custom(response.message)))
                        return
                    }

                    guard let payload = response.payload else {
                        completion(.failure(NetworkError.emptyData))
                        return
                    }
                    completion(.success(payload))

                } catch {
                    print("❌ Error al decodificar: \(error)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
