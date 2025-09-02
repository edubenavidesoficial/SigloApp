import Foundation

struct SectionsResponse: Codable {
    let requestDate: String
    let response: String
    let payload: [SectionsPayload]
    let processingTime: String

    private enum CodingKeys: String, CodingKey {
        case requestDate = "request_date"
        case response
        case payload
        case processingTime = "processing_time"
    }
}

struct SectionsPayload: Codable {
    let id: Int
    let titulo: String
    let tipo: String
    let logo: String?
    let nombre: String?
}
