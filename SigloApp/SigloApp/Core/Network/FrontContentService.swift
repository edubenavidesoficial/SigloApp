import Foundation

func fetchPortada(id: Int, token: String) {
    guard let url = URL(string: "\(API.baseURL)portadas/\(id)") else {
        print("URL inválida")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error en la solicitud: \(error)")
            return
        }
    }

    task.resume()
}

