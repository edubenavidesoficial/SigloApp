import Foundation

// MARK: - Error personalizado
enum PortadaServiceError: Error {
    case invalidURL
    case invalidResponse
    case emptyData
    case missingPayload(String)
    case decodingError(Error)
}

// MARK: - Servicio de portada
final class PortadaService {
    static let shared = PortadaService()
    private init() {}

    func obtenerPortada(completion: @escaping (Result<[SeccionPortada], Error>) -> Void) {
        guard let url = URL(string: "\(API.baseURL)portada/") else {
            print("❌ URL inválida")
            completion(.failure(PortadaServiceError.invalidURL))
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
                    completion(.failure(PortadaServiceError.invalidResponse))
                    return
                }

                print("📡 Código de estado: \(httpResponse.statusCode)")

                guard (200...299).contains(httpResponse.statusCode) else {
                    let message = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                    print("❌ Error HTTP: \(httpResponse.statusCode) - \(message)")
                    completion(.failure(PortadaServiceError.invalidResponse))
                    return
                }

                guard let data = data else {
                    print("❌ Datos vacíos")
                    completion(.failure(PortadaServiceError.emptyData))
                    return
                }

                // DEBUG opcional
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 JSON recibido K:\n\(jsonString.prefix(5000))...")
                }

                do {
                    // Decodificamos la respuesta completa
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(PortadaResponse.self, from: data)

                    // Iteramos sobre las secciones y verificamos si contienen 'notas'
                    var seccionesConNotas: [SeccionPortada] = []

                    for (key, seccion) in decodedResponse.payload {
                        if let notas = seccion.notas {
                            print("Sección \(key): \(String(describing: seccion.seccion))")
                            for _ in notas {}
                            seccionesConNotas.append(seccion)
                        } else {
                            print("Sección \(key) no contiene 'notas'")
                        }
                    }

                    // Llamamos a completion con las secciones que contienen notas
                    completion(.success(seccionesConNotas))

                } catch {
                    print("❌ Error al parsear JSON: \(error)")
                    completion(.failure(PortadaServiceError.decodingError(error)))
                }
            }
        }.resume()
    }
}
