import Foundation

final class SearchService {
    static let shared = SearchService()
    private init() {}

    func buscarPorTexto(_ query: String, completion: @escaping (Result<[ArticuloPayload], Error>) -> Void) {
        // Asegurar que la query esté codificada para URL
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(API.baseURL)buscar/texto/1?qry=\(encodedQuery)") else {
            print("❌ URL inválida o query mal formada")
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

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

                // DEBUG opcional
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 JSON recibido búsqueda:\n\(jsonString.prefix(500))...")
                }

                do {
                    let rawString = String(data: data, encoding: .utf8) ?? ""
                    if let jsonStartIndex = rawString.firstIndex(of: "{") {
                        let jsonString = String(rawString[jsonStartIndex...])
                        if let jsonData = jsonString.data(using: .utf8) {
                            let decoder = JSONDecoder()
                            let responseData = try decoder.decode(BusquedaResponsee.self, from: jsonData)
                            completion(.success(responseData.payload))
                            return
                        }
                    }

                    print("❌ JSON no contiene un objeto válido")
                    completion(.failure(NetworkError.decodingFailed))
                } catch {
                    print("❌ Error al decodificar JSON limpiado: \(error)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
