import Foundation

        final class SuplementsService {
            static let shared = SuplementsService()
            private init() {}

            func obtenerSuplementos(completion: @escaping (Result<[SuplementoPayload], Error>) -> Void) {
                guard let url = URL(string: "\(API.baseURL)suplementos/") else {
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
                            print("📦 JSON recibido suplementos:\n\(jsonString.prefix(500))...")
                        }

                        do {
                            let decoder = JSONDecoder()
                            let responseData = try decoder.decode(SuplementoResponse.self, from: data)
                            completion(.success(responseData.payload))
                        } catch {
                            print("❌ Error al decodificar JSON: \(error)")
                            completion(.failure(error))
                        }
                    }
                }.resume()
            }
        }
