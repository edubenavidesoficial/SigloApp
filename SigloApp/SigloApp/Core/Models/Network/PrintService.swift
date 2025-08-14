import Foundation

final class PrintService {
    static let shared = PrintService()
    private init() {}

    func obtenerPortada(pagina: Int = 1, completion: @escaping (Result<[NewspaperPayload], Error>) -> Void) {

        Task {
            do {
                var token: String
                if let storedToken = TokenService.shared.getStoredToken(),
                   !TokenService.shared.isTokenExpired(storedToken) {
                    token = storedToken
                    print("✅ Usando token almacenado")
                } else {
                    // Obtenemos un token nuevo
                    token = try await TokenService.shared.getToken(correoHash: "")
                    print("✅ Nuevo token generado")
                }

                guard let url = URL(string: "\(API.baseURL)impreso/lista/\(pagina)") else {
                    completion(.failure(NetworkError.invalidURL))
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

                let (data, response) = try await URLSession.shared.data(for: request)

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }

                // DEBUG: mostrar parte del JSON recibido
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 JSON recibido Print:\n\(jsonString.prefix(500))...")
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let responseData = try decoder.decode(NewspaperResponse.self, from: data)
                    completion(.success(responseData.payload))
                } catch {
                    print("❌ Error al decodificar JSON: \(error)")
                    completion(.failure(error))
                }

            } catch {
                completion(.failure(error))
            }
        }
    }
}
