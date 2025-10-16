import Foundation

struct PushService {
    
    @MainActor
    static func registerDevice(deviceType: Int, userId: Int, tokenBase64: String) async {
        do {
            let url = URL(string: "\(API.baseURL)push/\(deviceType)/\(userId)/\(tokenBase64)")!
            
            // Usamos la clase BaseService sin heredarla
            let base = BaseService()
            let request = try await base.authorizedRequest(url: url, method: "POST")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Registro de Push: \(httpResponse.statusCode)")
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data) {
                print("✅ Respuesta: \(json)")
            }
        } catch {
            print("❌ Error en registro de push: \(error.localizedDescription)")
        }
    }
}
