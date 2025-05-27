import Foundation

struct PrintModel: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let imageName: String
    let date: String
}
