import Foundation

final class NewsService {
    static let shared = NewsService()
    private init() {}
    
    func obtenerNoticia(idNoticia: Int, completion: @escaping (Result<NewsArticle, Error>) -> Void) {
        guard let url = URL(string: "\(API.baseURL)noticia/\(idNoticia)") else {
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
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode),
                      let data = data else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(NewsResponse.self, from: data)
                    
                    if let firstItem = response.payload.first {
                        completion(.success(firstItem)) // ✅ Devuelve solo la primera noticia
                    } else {
                        completion(.failure(NetworkError.emptyData))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
