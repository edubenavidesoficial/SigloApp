import Foundation

final class PrintDocService {
    static let shared = PrintDocService()
    private init() {}

    /// Descarga el PDF de portada y devuelve sus bytes en `Data`
    func descargarPortada(fecha: String,
                         edicion: String,
                         completion: @escaping (Result<Data, Error>) -> Void) {
        // 1. Obtener token
        guard let token = TokenService.shared.getStoredToken() else {
            completion(.failure(NetworkError.invalidToken))
            return
        }

        // 2. Construir URL
        let urlString = "\(API.baseURL)impreso/pdf/\(fecha)/\(edicion)/\(token)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        // 3. Solicitud
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let err = error {
                    completion(.failure(err))
                    return
                }
                guard let http = response as? HTTPURLResponse,
                      (200...299).contains(http.statusCode) else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                guard let data = data else {
                    completion(.failure(NetworkError.emptyData))
                    return
                }
                // ¡Aquí ya tienes los bytes del PDF!
                completion(.success(data))
            }
        }.resume()
    }
}
