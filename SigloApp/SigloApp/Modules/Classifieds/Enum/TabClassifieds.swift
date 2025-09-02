import Foundation

// Enum para las pestañas del menú clasificados
enum TabClassifieds: String, CaseIterable, Identifiable {
    case avisos = "AVISOS"
    case desplegados = "DESPLEGADOS"
    case esquelas = "ESQUELAS"
    case anunciate = "ANUNCIATE"

    var id: String { rawValue }
}
