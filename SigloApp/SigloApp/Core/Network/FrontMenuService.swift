import Foundation

// MARK: - Servicio para obtener Portadas del Menú Superior
final class IngresPortadaMenuSuperiorService {
    static let shared = IngresPortadaMenuSuperiorService()
    private init() {}

    func obtenerPortadas(completion: @escaping (Result<[PortadaMenu], Error>) -> Void) {
        guard let url = URL(string: "\(API.baseURL)portadas/") else {
            print("❌ URL inválida")
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Agregar token si está disponible
        if let token = TokenService.shared.getStoredToken() {
            print("✅ Token disponible: \(token)")
            request.setValue("\(token)", forHTTPHeaderField: "Authorization")
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
                    print("📦 JSON recibido portadas menú superior:\n\(jsonString.prefix(500))...")
                }

                do {
                    let decoder = JSONDecoder()
                    let responseData = try decoder.decode(PortadaMenuResponse.self, from: data)
                    
                    if responseData.response == "Success" {
                        completion(.success(responseData.payload))
                    } else {
                        print("❌ Respuesta con error: \(responseData.response)")
                        completion(.failure(NetworkError.invalidResponse))
                    }
                } catch {
                    print("❌ Error al decodificar JSON: \(error)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
