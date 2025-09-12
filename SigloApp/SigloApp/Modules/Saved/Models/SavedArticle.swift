import Foundation

struct SavedArticle: Identifiable, Codable {
    var id = UUID()
    var category: String
    var title: String
    var author: String
    var location: String
    var time: String
    var imageName: String
    var description: String?
}
