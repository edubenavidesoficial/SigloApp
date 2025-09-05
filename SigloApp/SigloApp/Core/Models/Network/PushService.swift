import Foundation

struct PushService {
    
    static func registerDevice(deviceType: Int, userId: Int, tokenBase64: String, authToken: String) {
        
        // Construir URL
        let urlString = "\(API.baseURL)push/\(deviceType)/\(userId)/\(tokenBase64)"
        guard let url = URL(string: urlString) else {
            print("❌ URL inválida de push")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Aquí usas el token que guardaste en TokenService
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        // Llamada a la API
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("❌ Error en la petición: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("❌ Respuesta vacía")
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                print("Respuesta de registro Push: \(json)")
            } else {
                print("No se pudo parsear Push JSON")
            }
        }
        
        task.resume()
    }
}

