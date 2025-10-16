import Foundation

@MainActor
func fetchPortada(id: Int) async {
    do {
        guard let url = URL(string: "\(API.baseURL)portadas/\(id)") else {
            print("URL inválida")
            return
        }

        // Crear request autorizado usando BaseService
        let base = BaseService()
        let request = try await base.authorizedRequest(url: url, method: "GET")
        let (data, response) = try await URLSession.shared.data(for: request)

        // Verificar status HTTP
        if let httpResponse = response as? HTTPURLResponse {
            print("📡 Código de estado: \(httpResponse.statusCode)")
        }

        // Opcional: imprimir JSON recibido
        if let dataString = String(data: data, encoding: .utf8) {
            print("📦 JSON recibido: \(dataString.prefix(500))...")
        }

    } catch {
        print("❌ Error al obtener la portada: \(error)")
    }
}
