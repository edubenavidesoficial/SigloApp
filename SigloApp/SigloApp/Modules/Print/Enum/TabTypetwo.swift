import Foundation

// Tu enum de pestañas
enum TabTypetwo: String, CaseIterable, Identifiable {
    case hemeroteca = "HEMEROTECA EL SIGLO DE TORREÓN"
    case suplementos = "SUPLEMENTOS"
    case descargas = "MIS DESCARGAS"
    var id: String { rawValue }
}
