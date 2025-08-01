import Foundation

final class NewsService {
    static let shared = NewsService()
    private init() {}

    func obtenerNoticia(idNoticia: Int, completion: @escaping (Result<NewsArticle, Error>) -> Void) {
        guard let url = URL(string: "\(API.baseURL)noticia/\(idNoticia)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = TokenService.shared.getStoredToken() {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode),
                      let data = data else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }

                // --- Imprimir JSON para depuración ---
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON recibido News:\n\(jsonString)")
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase

                    let response = try decoder.decode(NewsResponse.self, from: data)
                    let noticia = response.payload

                    // --- Verificación de datos ---
                    print("relacionadas count:", noticia.relacionadas?.count ?? 0)
                    print("masNotas count:", noticia.masNotas?.count ?? 0)

                    completion(.success(noticia))
                } catch {
                    print("❌ Error al decodificar JSON: \(error)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
