import Foundation

final class SectionService {
    static let shared = SectionService()
    private init() {}
    
    func obtenerContenidoDeSeccion(idSeccion: Int, completion: @escaping (Result<SectionPayload, Error>) -> Void) {
        guard let url = URL(string: "\(API.baseURL)seccion/\(idSeccion)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        print("🌐 URL generada: \(url.absoluteString)")

        // 2. Crear request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // 3. Agregar token si está disponible
        if let token = TokenService.shared.getStoredToken() {
            print("✅ Token disponible: \(token)")
            request.setValue(token, forHTTPHeaderField: "Authorization")
        } else {
            print("⚠️ Token no disponible")
        }

        // 4. Iniciar llamada
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

                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 JSON recibido Seccion:\n\(jsonString.prefix(20000))...")
                }

                // 5. Decodificación
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(SectionSingleResponse.self, from: data)
                    completion(.success(response.payload))
                } catch {
                    print("❌ Error al decodificar JSON: \(error)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
