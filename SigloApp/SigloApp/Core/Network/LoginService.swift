//
//  LoginService.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/14/25.
//
import Foundation
import CryptoKit

struct LoginService {
    static func md5(_ string: String) -> String {
        let digest = Insecure.MD5.hash(data: Data(string.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    static func login(correo: String, password: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let correoHash = md5(correo)
        let passwordHash = md5(password)

        let urlString = "https://www.elsiglodetorreon.com.mx/api/app/v1/login/s/\(correoHash)/\(passwordHash)"

        guard let url = URL(string: urlString) else {
            print("URL inválida")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                completion(.success(data))
            }
        }.resume()
    }
}
