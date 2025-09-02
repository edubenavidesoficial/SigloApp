import Foundation

final class IngresPortadasService {
    static let shared = IngresPortadasService()
    private init() {}

    enum IngresPortadasServiceError: Error {
        case invalidURL
        case invalidResponse
        case emptyData
        case decodingError(Error)
        case responseError(String)
    }

    func obtenerPortadas(completion: @escaping (Result<[IngresPortada], Error>) -> Void) {
        guard let url = URL(string: "\(API.baseURL)portadas/") else {
            print("❌ URL inválida")
            completion(.failure(IngresPortadasServiceError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Agregar token si está disponible
        if let token = TokenService.shared.getStoredToken() {
            print("✅ Token disponible: \(token)")
            request.setValue(token, forHTTPHeaderField: "Authorization")
        } else {
            print("⚠️ Token no disponible")
            // Si el token es obligatorio, se puede fallar aquí
            completion(.failure(IngresPortadasServiceError.responseError("Token no disponible")))
            return
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
                    completion(.failure(IngresPortadasServiceError.invalidResponse))
                    return
                }

                print("📡 Código de estado: \(httpResponse.statusCode)")

                guard (200...299).contains(httpResponse.statusCode) else {
                    let message = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                    print("❌ Error HTTP: \(httpResponse.statusCode) - \(message)")
                    completion(.failure(IngresPortadasServiceError.invalidResponse))
                    return
                }

                guard let data = data else {
                    print("❌ Datos vacíos")
                    completion(.failure(IngresPortadasServiceError.emptyData))
                    return
                }

                // DEBUG opcional
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 JSON recibido Ingres Portadas:\n\(jsonString.prefix(1000))...")
                }

                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(IngresPortadasResponse.self, from: data)

                    if decodedResponse.response == "Success" {
                        completion(.success(decodedResponse.payload))
                    } else {
                        print("❌ Respuesta del servidor: \(decodedResponse.response)")
                        completion(.failure(IngresPortadasServiceError.responseError(decodedResponse.response)))
                    }

                } catch {
                    print("❌ Error al parsear JSON: \(error)")
                    completion(.failure(IngresPortadasServiceError.decodingError(error)))
                }
            }
        }.resume()
    }
}
