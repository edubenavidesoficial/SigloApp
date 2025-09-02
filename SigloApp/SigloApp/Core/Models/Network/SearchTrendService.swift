import Foundation

struct SearchTrendService {
    static let shared = SearchTrendService()
    private init() {}

    func fetchTendencias(tendenciaID: Int,pagina: Int,token: String,completion: @escaping (Result<[TendenciaArticulo], Error>) -> Void) {
        guard let url = URL(string: "\(API.baseURL)buscar/tendencias/\(tendenciaID)/\(pagina)") else {
            print("❌ URL inválida para búsqueda por tema")
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Sin datos", code: -1)))
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(TendenciaResponse.self, from: data)
                if decoded.response.lowercased() == "success" {
                    DispatchQueue.main.async {
                        completion(.success(decoded.payload))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "Respuesta fallida", code: -2)))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
