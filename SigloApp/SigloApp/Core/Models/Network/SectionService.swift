import Foundation

final class SectionService {
    static let shared = SectionService()
    private init() {}

    func obtenerContenidoDeSeccion(idSeccion: Int, completion: @escaping (Result<SectionPayload, Error>) -> Void) {
        guard let url = URL(string: "\(API.baseURL)seccion/\(idSeccion)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        if let token = TokenService.shared.getStoredToken() {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode),
                      let data = data else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase

                    let response = try decoder.decode(SectionResponse.self, from: data)

                    if response.response == "Success" {
                        completion(.success(response.payload))
                    } else {
                        let msg = response.message ?? "Error desconocido"
                        completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: msg])))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
