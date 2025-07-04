import Foundation

enum TabClassifieds: String, CaseIterable, Identifiable {
    case avisos, desplegados, esquelas, anunciate

    var id: String { self.rawValue }
}
