import Foundation

final class AdsService {
    static let shared = AdsService()
    private init() {}

    func fetchAds(completion: @escaping (Result<[ClassifiedAd], Error>) -> Void) {
        guard let url = URL(string: "\(API.baseURL)clasificados/anuncios/") else {
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

                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 JSON Ads:\n\(jsonString)")
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(AdsResponse.self, from: data)
                    completion(.success(response.payload))
                } catch {
                    print("❌ Failed to decode Ads: \(error)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
