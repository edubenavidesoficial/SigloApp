import Foundation

// Modelo para la respuesta completa
struct PortadaResponse: Decodable {
    let request_date: String
    let response: String
    let version: String
    let payload: [String: SeccionPortada] // El payload es un diccionario con diferentes claves de secciones
}

// Modelo para la sección de la portada
struct SeccionPortada: Decodable {
    let seccion: String?
    let mostrar_titulo: Int
    let notas: [Nota]? // 'notas' es opcional, ya que puede no existir en algunas secciones
}

// Modelo para la nota
struct Nota: Decodable, Sendable {
    let id: Int
    let sid: Int
    let fecha: String
    let fechamod: String
    let fecha_formato: String
    let titulo: String
    let localizador: String
    let balazo: String?
    let autor: String
    let ciudad: String
    let contenido: [String]
}

// Función para cargar y decodificar el JSON
func loadData() {
    let jsonString = """
    {
        "135": {
            "seccion": "Portada",
            "notas": [
                {
                    "id": 2372175,
                    "sid": 26,
                    "fecha": "2025-03-26",
                    "fechamod": "2025-03-26 20:00:05",
                    "fechaFormato": "20:00",
                    "titulo": "Coahuila conmemora el 112 aniversario de la firma del Plan de Guadalupe",
                    "localizador": "GOBIERNO DE COAHUILA",
                    "balazo": "Las autoridades reafirman el compromiso de Coahuila con los principios...",
                    "fotos": [
                        {
                            "url": "http://example.com/image1.jpg",
                            "descripcion": "Imagen de ejemplo"
                        }
                    ]
                }
            ]
        }
    }
    """
    
    // Convertimos el String JSON a Data
    if let jsonData = jsonString.data(using: .utf8) {
        do {
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode([String: SeccionPortada].self, from: jsonData)
            
            // Accedemos a la sección con id "135" y mostramos la información
            if let portada = decodedResponse["135"] {
                 
            }
        } catch {
            print("Error al decodificar JSON: \(error)")
        }
    } else {
        print("Error al convertir JSON string a Data")
    }
}
