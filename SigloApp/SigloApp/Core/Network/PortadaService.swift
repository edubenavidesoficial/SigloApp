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
        guard let url = URL(string: "https://www.elsiglodetorreon.com.mx/api/app/v1/portada/") else {
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
                    print("📦 JSON recibido:\n\(jsonString.prefix(500))...")
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // Verificamos si 'payload' está en el JSON
                        guard let payload = json["payload"] as? [String: Any] else {
                            let mensaje = json["message"] as? String ?? "Falta el campo 'payload'"
                            print("⚠️ Error en respuesta: \(mensaje)")
                            completion(.failure(PortadaServiceError.missingPayload(mensaje)))
                            return
                        }

                        var nuevasSecciones: [SeccionPortada] = []

                        // Iteramos sobre las claves dentro de 'payload'
                        for (_, value) in payload {
                            if let dict = value as? [String: Any],
                               let nombreSeccion = dict["seccion"] as? String,
                               let notasArray = dict["notas"] as? [[String: Any]] {

                                // Decodificamos las notas usando JSONDecoder
                                let jsonNotas = try JSONSerialization.data(withJSONObject: notasArray)
                                let notas = try JSONDecoder().decode([Nota].self, from: jsonNotas)

                                nuevasSecciones.append(SeccionPortada(seccion: nombreSeccion, notas: notas))
                            }
                        }

                        // Devolvemos las secciones como éxito
                        print("✅ Secciones cargadas: \(nuevasSecciones.count)")  // Para depuración
                        completion(.success(nuevasSecciones))
                    } else {
                        print("❌ Error: JSON no tiene la estructura esperada")
                        completion(.failure(PortadaServiceError.decodingError(NSError(domain: "", code: 0, userInfo: nil))))
                    }
                } catch {
                    print("❌ Error al parsear JSON: \(error)")
                    completion(.failure(PortadaServiceError.decodingError(error)))
                }
            }
        }.resume()
    }
}
