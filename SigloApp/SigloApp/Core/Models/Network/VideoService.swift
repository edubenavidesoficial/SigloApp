import Foundation

final class VideoService {
    static let shared = VideoService()
    private init() {}

    func obtenerVideo(tipo: String, id: Int, completion: @escaping (Result<VideoPayload, Error>) -> Void) {
        let urlString = "\(API.baseURL)video/\(tipo)/\(id)"
        guard let url = URL(string: urlString) else {
            print("❌ URL inválida: \(urlString)")
            completion(.failure(NetworkError.invalidURL))
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

                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 JSON recibido:\n\(jsonString.prefix(500))...")
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let responseData = try decoder.decode(VideoResponse.self, from: data)
                    completion(.success(responseData.payload))
                } catch {
                    print("❌ Error al decodificar JSON: \(error)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
