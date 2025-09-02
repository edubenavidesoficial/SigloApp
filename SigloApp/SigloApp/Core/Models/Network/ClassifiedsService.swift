import Foundation

final class ClassifiedsService {
    static let shared = ClassifiedsService()
    private init() {}

    func obtenerCategorias(completion: @escaping (Result<[String: ClasificadoSeccion], Error>) -> Void) {
        guard let url = URL(string: "\(API.baseURL)clasificados/categorias/") else {
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

                // 🧪 Mostrar JSON crudo en consola para depurar
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 JSON Clasificados:\n\(jsonString)")
                }

                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(ClasificadosResponse.self, from: data)
                    completion(.success(response.payload))
                } catch {
                    print("❌ Error al decodificar JSON: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
