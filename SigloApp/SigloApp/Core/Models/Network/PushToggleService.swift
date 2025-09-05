import Foundation

@MainActor
final class PushToggleService {
    
    static func setPush(enabled: Bool, tokenBase64: String, authToken: String) async {
        let action = enabled ? "encender" : "apagar"
        let urlString = "\(API.baseURL)push/\(action)/\(tokenBase64)"
        
        guard let url = URL(string: urlString) else {
            print("❌ URL inválida")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse {
                print("📡 Código HTTP: \(http.statusCode)")
            }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                print("✅ Respuesta Push toggle: \(json)")
            }
        } catch {
            print("❌ Error al cambiar estado de Push: \(error)")
        }
    }
}
