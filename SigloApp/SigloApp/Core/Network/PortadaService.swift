import Foundation

class PortadaService {
    static let shared = PortadaService()

    private init() {}

    func obtenerPortada(completion: @escaping (Result<[SeccionPortada], Error>) -> Void) {
        guard let url = URL(string: "https://www.elsiglodetorreon.com.mx/api/app/v1/portada/s") else {
            completion(.failure(NSError(domain: "URL inválida", code: 0)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "Datos vacíos", code: 0)))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let payload = json?["payload"] as? [String: Any] {
                    var nuevasSecciones: [SeccionPortada] = []

                    for (_, value) in payload {
                        if let dict = value as? [String: Any],
                           let nombreSeccion = dict["sección"] as? String,
                           let notasArray = dict["notas"] as? [[String: Any]] {

                            let jsonNotas = try JSONSerialization.data(withJSONObject: notasArray)
                            let notas = try JSONDecoder().decode([Nota].self, from: jsonNotas)
                            let seccion = SeccionPortada(seccion: nombreSeccion, notas: notas)
                            nuevasSecciones.append(seccion)
                        }
                    }

                    completion(.success(nuevasSecciones))
                } else {
                    completion(.failure(NSError(domain: "Formato inesperado", code: 0)))
                }
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }
}
