import Foundation

final class AnunciosService {
    static let shared = AnunciosService()
    private init() {}

    func obtenerAnuncios(tipo: String, completion: @escaping (Result<[AnuncioSeccion], Error>) -> Void) {
        guard let url = URL(string: "\(API.baseURL)anuncios/\(tipo)/") else {
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
                    print("❌ Error de red: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode),
                      let data = data else {
                    print("❌ Respuesta inválida del servidor")
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }

                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 JSON Anuncios Des:\n\(jsonString.prefix(2000))...")
                }

                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(AnuncioResponse.self, from: data)
                    completion(.success(response.payload))
                } catch let decodingError as DecodingError {
                    switch decodingError {
                    case .typeMismatch(let type, let context):
                        print("❌ Type mismatch: \(type) – \(context.debugDescription)")
                        print("   CodingPath:", context.codingPath.map { $0.stringValue }.joined(separator: " -> "))
                    case .valueNotFound(let type, let context):
                        print("❌ Value not found: \(type) – \(context.debugDescription)")
                        print("   CodingPath:", context.codingPath.map { $0.stringValue }.joined(separator: " -> "))
                    case .keyNotFound(let key, let context):
                        print("❌ Key not found: \(key.stringValue) – \(context.debugDescription)")
                        print("   CodingPath:", context.codingPath.map { $0.stringValue }.joined(separator: " -> "))
                    case .dataCorrupted(let context):
                        print("❌ Data corrupted: \(context.debugDescription)")
                        print("   CodingPath:", context.codingPath.map { $0.stringValue }.joined(separator: " -> "))
                    @unknown default:
                        print("❌ Unknown decoding error: \(decodingError.localizedDescription)")
                    }
                    completion(.failure(decodingError))
                } catch {
                    print("❌ Otro error al decodificar JSON: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
