import Foundation

@MainActor
final class PushToggleService {
    
    static func setPush(enabled: Bool, tokenBase64: String) async {
        do {
            let action = enabled ? "encender" : "apagar"
            let url = URL(string: "\(API.baseURL)push/\(action)/\(tokenBase64)")!
            
            // Usamos BaseService para manejar el token automáticamente
            let base = BaseService()
            let request = try await base.authorizedRequest(url: url, method: "POST")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let http = response as? HTTPURLResponse {
                print("📡 Código HTTP: \(http.statusCode)")
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                print("✅ Respuesta Push toggle: \(json)")
            }
        } catch {
            print("❌ Error al cambiar estado de Push: \(error.localizedDescription)")
        }
    }
}
