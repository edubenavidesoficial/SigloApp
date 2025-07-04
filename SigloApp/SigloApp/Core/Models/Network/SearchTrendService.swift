import Foundation

struct SearchTrendService {
    static let shared = TrendSearchService()
    private init() {}

    /// Realiza la búsqueda por tendencia específica.
    ///
    /// - Parameters:
    ///   - tendenciaID: ID numérico de la tendencia a consultar.
    ///   - pagina: Número de página para paginación.
    ///   - token: Token JWT de autorización.
    ///   - completion: Cierre que devuelve un resultado con el array de artículos o un error.
    func fetchTendencias(
        tendenciaID: Int,
        pagina: Int,
        token: String,
        completion: @escaping (Result<[TendenciaArticulo], Error>) -> Void
    ) {
        let urlString = "https://www.elsiglodetorreon.com.mx/api/app/v1/buscar/tendencias/\(tendenciaID)/\(pagina)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "URL inválida", code: -1)))
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
