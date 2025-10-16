import Foundation

/// Clase base para todos los servicios que requieren autenticación
class BaseService {
    
    /// Devuelve un `URLRequest` con token válido automáticamente
    @MainActor
    func authorizedRequest(
        url: URL,
        method: String = "GET",
        body: Data? = nil,
        contentType: String = "application/json"
    ) async throws -> URLRequest {
        
        let token = try await TokenService.shared.getValidToken()
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
