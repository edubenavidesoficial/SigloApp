import Foundation

// MARK: - Servicio para obtener Portadas del Menú Superior
final class IngresPortadaMenuSuperiorService {
    static let shared = IngresPortadaMenuSuperiorService()
    private init() {}

    func obtenerPortadas(completion: @escaping (Result<[PortadaMenu], Error>) -> Void) {
        Task {
            do {
                // Obtener token válido automáticamente
                let token = try await TokenService.shared.getValidToken()

                // Construir URL
                guard let url = URL(string: "\(API.baseURL)portadas/") else {
                    completion(.failure(NetworkError.invalidURL))
                    return
                }

                // Crear request usando BaseService
                let base = BaseService()
                let request = try await base.authorizedRequest(url: url, method: "GET")

                // Realizar request
                let (data, response) = try await URLSession.shared.data(for: request)

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }

                guard !data.isEmpty else {
                    completion(.failure(NetworkError.emptyData))
                    return
                }

                // DEBUG opcional
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 JSON recibido portadas menú superior:\n\(jsonString.prefix(500))...")
                }

                // Decodificar JSON
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let responseData = try decoder.decode(PortadaMenuResponse.self, from: data)

                if responseData.response == "Success" {
                    completion(.success(responseData.payload))
                } else {
                    print("❌ Respuesta con error: \(responseData.response)")
                    completion(.failure(NetworkError.invalidResponse))
                }

            } catch {
                completion(.failure(error))
            }
        }
    }
}
