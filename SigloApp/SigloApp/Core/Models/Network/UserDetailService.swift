import Foundation

final class UserDetailService {
    static let shared = UserDetailService()
    private init() {}

    func obtenerDetallesUsuario(usuarioId: Int, completion: @escaping (Result<UserDetailPayload, Error>) -> Void) {
        guard let url = URL(string: "\(API.baseURL)usuario/\(usuarioId)") else {
            print("❌ URL inválida")
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
                    print("❌ Error HTTP: \(httpResponse.statusCode)")
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }

                guard let data = data else {
                    print("❌ Datos vacíos")
                    completion(.failure(NetworkError.emptyData))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase

                    let response = try decoder.decode(UserSuccessResponse.self, from: data)
                    completion(.success(response.payload))

                } catch let decodingError as DecodingError {
                    print("❌ Error al decodificar JSON: \(decodingError.localizedDescription)")
                    completion(.failure(NetworkError.decodingError(decodingError)))

                } catch {
                    // Error inesperado
                    print("❌ Error inesperado: \(error.localizedDescription)")
                    completion(.failure(error))
                }

            }
        }.resume()
    }
}
