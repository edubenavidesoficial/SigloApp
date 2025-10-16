import Foundation

enum VideoServiceError: Error {
    case invalidURL
    case invalidResponse
    case emptyData
    case decodingError(Error)
}

final class VideoService {
    static let shared = VideoService()
    private init() {}

    @MainActor
    func obtenerVideo(tipo: String, id: Int) async -> Result<VideoPayload, Error> {
        let urlString = "\(API.baseURL)video/\(tipo)/\(id)"
        guard let url = URL(string: urlString) else {
            print("❌ URL inválida: \(urlString)")
            return .failure(VideoServiceError.invalidURL)
        }

        do {
            // Obtener token válido automáticamente
            let authToken = try await TokenService.shared.getValidToken()

            // Crear request con BaseService para agregar headers
            let base = BaseService()
            let request = try await base.authorizedRequest(url: url, method: "GET")

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Respuesta no válida")
                return .failure(VideoServiceError.invalidResponse)
            }

            print("📡 Código de estado: \(httpResponse.statusCode)")

            guard (200...299).contains(httpResponse.statusCode) else {
                let message = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                print("❌ Error HTTP: \(httpResponse.statusCode) - \(message)")
                return .failure(VideoServiceError.invalidResponse)
            }

            guard !data.isEmpty else {
                print("❌ Datos vacíos")
                return .failure(VideoServiceError.emptyData)
            }

            // DEBUG opcional
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 JSON recibido video:\n\(jsonString.prefix(500))...")
            }

            // Decodificar JSON
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let responseData = try decoder.decode(VideoResponse.self, from: data)
            return .success(responseData.payload)

        } catch {
            print("❌ Error VideoService: \(error)")
            return .failure(VideoServiceError.decodingError(error))
        }
    }
}
