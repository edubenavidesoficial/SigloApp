import Foundation

final class SearchTopicService {
    static let shared = SearchTopicService()
    private init() {}

    func buscarPorTema(idTema: Int, pagina: Int, completion: @escaping (Result<[ArticuloPayload], Error>) -> Void) {
        // Construir la URL completa
        guard let url = URL(string: "\(API.baseURL)buscar/temas/\(idTema)/\(pagina)") else {
            print("❌ URL inválida para búsqueda por tema")
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Agregar token al header
        if let token = TokenService.shared.getStoredToken() {
            print("✅ Token disponible: \(token)")
            request.setValue(token, forHTTPHeaderField: "Authorization")
        } else {
            print("⚠️ Token no disponible")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Error en la solicitud: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ Respuesta no válida")
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }

                print("📡 Código de estado: \(httpResponse.statusCode)")

                guard (200...299).contains(httpResponse.statusCode) else {
                    let message = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                    print("❌ Error HTTP: \(httpResponse.statusCode) - \(message)")
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }

                guard let data = data else {
                    print("❌ Datos vacíos")
                    completion(.failure(NetworkError.emptyData))
                    return
                }

                // Debug opcional
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 JSON recibido por tema:\n\(jsonString.prefix(500))...")
                }

                do {
                    let decoder = JSONDecoder()
                    let responseData = try decoder.decode(BusquedaResponsee.self, from: data)
                    completion(.success(responseData.payload))
                } catch {
                    print("❌ Error al decodificar JSON: \(error)")
                    completion(.failure(NetworkError.decodingFailed))
                }
            }
        }.resume()
    }
}
