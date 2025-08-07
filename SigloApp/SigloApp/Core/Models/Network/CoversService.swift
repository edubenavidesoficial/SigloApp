import Foundation

enum PortadasServiceError: Error {
    case invalidURL
    case invalidResponse
    case emptyData
    case decodingError(Error)
    case serverError
}

final class CoversService {
    static let shared = CoversService()
    private init() {}
    
    func obtenerPortadaMinutos(completion: @escaping (Result<SectionPayload, Error>) -> Void) {
        guard let url = URL(string: "\(API.baseURL)portadas/205") else {
            completion(.failure(PortadasServiceError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        if let token = TokenService.shared.getStoredToken() {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                completion(.failure(PortadasServiceError.invalidResponse))
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(SectionSingleResponse.self, from: data)
                completion(.success(response.payload))   // ahora devuelve un solo objeto
            } catch {
                print("❌ Error al decodificar JSON: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
