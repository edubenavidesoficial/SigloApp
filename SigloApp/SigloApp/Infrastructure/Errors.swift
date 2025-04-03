import Foundation

enum LoginServiceError: Error {
    case invalidURL
    case emptyData
    case custom(String)
    case decodingError(Error)
}
