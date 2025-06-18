import Foundation

struct SectionsResponse: Codable {
    let requestDate: String
    let response: String
    let payload: [SectionPayload]
    let processingTime: String
}

struct SectionsPayload: Codable {
    let id: Int
    let titulo: String
    let tipo: String
    let logo: String?
}
