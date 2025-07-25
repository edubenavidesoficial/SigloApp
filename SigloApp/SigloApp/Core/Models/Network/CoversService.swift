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
    
    func obtenerPortadas(completion: @escaping (Result<[Nota], Error>) -> Void) {
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
            DispatchQueue.main.async {
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
                
                // ✅ Mostrar JSON crudo
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 JSON crudo recibido:\n\(jsonString)")
                }
                
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(PortadaResponse.self, from: data)
                    
                    guard decodedResponse.response == "Success" else {
                        completion(.failure(PortadasServiceError.serverError))
                        return
                    }
                    
                  
                    
                } catch {
                    completion(.failure(PortadasServiceError.decodingError(error)))
                }
            }
        }.resume()
    }
}
